package backend.servlet;

import backend.dao.ResultDao;
import backend.dao.TestDao;
import backend.entity.*;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@WebServlet(urlPatterns = "/tests/*")
public class TestServlet extends HttpServlet {
    private TestDao dao;
    private ResultDao resultDao;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        dao = (TestDao) config.getServletContext().getAttribute("testDao");
        resultDao = (ResultDao) config.getServletContext().getAttribute("resultDao");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String pathInfo = req.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            resp.sendRedirect(req.getContextPath() + "/main");
            return;
        }

        UUID id;
        try {
            id = UUID.fromString(pathInfo.substring(1));
        } catch (IllegalArgumentException e) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        Optional<Test> test = dao.findById(id);
        if (test.isEmpty()) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        req.setAttribute("test", test.get());
        req.getRequestDispatcher("/WEB-INF/views/test.jsp")
                .forward(req, resp);
    }

    private void createTest(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String title = req.getParameter("title");
        String topic = req.getParameter("topic");

        if (title == null || title.isBlank() || title.trim().length() > 100
                || topic == null || topic.isBlank() || topic.trim().length() > 50) {
            resp.sendRedirect(req.getContextPath() + "/main");
            return;
        }

        User admin = (User) req.getSession().getAttribute("user");

        Test test = Test.builder()
                .id(UUID.randomUUID())
                .title(title.trim())
                .topic(topic.trim())
                .createdBy(admin.getId())
                .questions(new ArrayList<>())
                .build();

        dao.save(test);
        resp.sendRedirect(req.getContextPath() + "/admin/tests/" + test.getId());
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String pathInfo = req.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            createTest(req, resp);
            return;
        }
        String[] parts = (pathInfo == null) ? new String[0] : pathInfo.split("/");
        if (parts.length != 3 || !parts[2].equals("submit")) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        UUID testId;
        try {
            testId = UUID.fromString(parts[1]);
        } catch (IllegalArgumentException e) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        Optional<Test> optionalTest = dao.findById(testId);
        if (optionalTest.isEmpty()) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        Test test = optionalTest.get();

        User user = (User) req.getSession().getAttribute("user");

        List<AnswerResult> answers = new ArrayList<>();
        int score = 0;

        for (Question q : test.getQuestions()) {
            String selected = req.getParameter("q-" + q.getId());

            UUID selectedId = null;
            if (selected != null) {
                try {
                    selectedId = UUID.fromString(selected);
                } catch (IllegalArgumentException ignored) {
                }
            }

            Answer matched = null;
            for (Answer a : q.getAnswers()) {
                if (a.getId().equals(selectedId)) {
                    matched = a;
                    break;
                }
            }

            boolean correct = matched != null && matched.isCorrect();
            if (correct) {
                score++;
            }

            answers.add(AnswerResult.builder()
                    .questionId(q.getId())
                    .selectedAnswerId(matched == null ? null : matched.getId())
                    .correct(correct)
                    .build());
        }

        Result result = Result.builder()
                .id(UUID.randomUUID())
                .userId(user.getId())
                .testId(testId)
                .date(LocalDateTime.now())
                .score(score)
                .total(test.getQuestions().size())
                .answers(answers)
                .build();

        resultDao.save(result);

        resp.sendRedirect(req.getContextPath() + "/results/" + result.getId());
    }
}

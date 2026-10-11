package backend.servlet;

import backend.dao.TestDao;
import backend.entity.*;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@WebServlet(urlPatterns = "/admin/tests/*")
public class AdminTestServlet extends HttpServlet {
    private TestDao dao;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        dao = (TestDao) config.getServletContext().getAttribute("testDao");
    }

    // GET /admin/tests/{id} : страница редактирования
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String[] parts = parts(req);
        if (parts.length != 2) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        Test test = loadTest(parts, resp);
        if (test == null) {
            return;   // ответ 404 уже отправлен внутри loadTest
        }
        req.setAttribute("test", test);
        req.getRequestDispatcher("/WEB-INF/views/edit.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String[] parts = parts(req);
        Test test = loadTest(parts, resp);
        if (test == null) {
            return;
        }
        String base = req.getContextPath() + "/admin/tests/" + test.getId();

        if (parts.length == 3 && parts[2].equals("delete")) {
            dao.delete(test.getId());
            resp.sendRedirect(req.getContextPath() + "/main");
        } else if (parts.length == 3 && parts[2].equals("update")) {
            updateDetails(req, resp, test, base);
        } else if (parts.length == 3 && parts[2].equals("questions")) {
            addQuestion(req, resp, test, base);
        } else if (parts.length == 5 && parts[2].equals("questions") && parts[4].equals("delete")) {
            deleteQuestion(resp, test, parts[3], base);
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    private String[] parts(HttpServletRequest req) {
        String pathInfo = req.getPathInfo();
        return pathInfo == null ? new String[0] : pathInfo.split("/");
    }

    private UUID parseUuid(String s) {
        try {
            return UUID.fromString(s);
        } catch (IllegalArgumentException e) {
            return null;
        }
    }

    private Test loadTest(String[] parts, HttpServletResponse resp) throws IOException {
        UUID id = parts.length > 1 ? parseUuid(parts[1]) : null;
        Optional<Test> test = (id == null) ? Optional.empty() : dao.findById(id);
        if (test.isEmpty()) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return null;
        }
        return test.get();
    }

    private void updateDetails(HttpServletRequest req, HttpServletResponse resp, Test test, String base)
            throws IOException {
        String title = req.getParameter("title");
        String topic = req.getParameter("topic");

        if (title == null || title.isBlank() || title.trim().length() > 100
                || topic == null || topic.isBlank() || topic.trim().length() > 50) {
            resp.sendRedirect(base + "?error=details");
            return;
        }

        test.setTitle(title.trim());
        test.setTopic(topic.trim());
        dao.save(test);
        resp.sendRedirect(base);
    }

    private void addQuestion(HttpServletRequest req, HttpServletResponse resp, Test test, String base)
            throws IOException {
        String text = req.getParameter("text");
        String correctParam = req.getParameter("correct");   // "1".."4": номер правильного варианта

        if (text == null || text.isBlank() || text.trim().length() > 300 || correctParam == null) {
            resp.sendRedirect(base + "?error=question");
            return;
        }

        List<Answer> answers = new ArrayList<>();
        boolean hasCorrect = false;

        for (int i = 1; i <= 4; i++) {
            String answerText = req.getParameter("answer" + i);
            if (answerText == null || answerText.isBlank()) {
                continue;   // пустые варианты просто пропускаем
            }
            boolean isCorrect = String.valueOf(i).equals(correctParam);
            hasCorrect = hasCorrect || isCorrect;

            Answer answer = new Answer();
            answer.setId(UUID.randomUUID());
            answer.setText(answerText.trim());
            answer.setCorrect(isCorrect);
            answers.add(answer);
        }

        if (answers.size() < 2 || !hasCorrect) {
            resp.sendRedirect(base + "?error=question");
            return;
        }

        Question question = new Question();
        question.setId(UUID.randomUUID());
        question.setText(text.trim());
        question.setAnswers(answers);

        test.getQuestions().add(question);
        dao.save(test);
        resp.sendRedirect(base);
    }

    private void deleteQuestion(HttpServletResponse resp, Test test, String questionIdPart, String base)
            throws IOException {
        UUID questionId = parseUuid(questionIdPart);
        if (questionId == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        test.getQuestions().removeIf(q -> q.getId().equals(questionId));
        dao.save(test);
        resp.sendRedirect(base);
    }
}
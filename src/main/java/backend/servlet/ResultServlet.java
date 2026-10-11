package backend.servlet;

import backend.dao.ResultDao;
import backend.dao.TestDao;
import backend.dto.ReviewItem;
import backend.entity.*;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.*;

@WebServlet(urlPatterns = "/results/*")
public class ResultServlet extends HttpServlet {
    private ResultDao resultDao;
    private TestDao testDao;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        resultDao = (ResultDao) config.getServletContext().getAttribute("resultDao");
        testDao = (TestDao) config.getServletContext().getAttribute("testDao");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        String pathInfo = req.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            showHistory(req, resp, user);
        } else {
            showDetails(req, resp, user, pathInfo.substring(1));
        }
    }

    // GET /results : история прохождений текущего пользователя
    private void showHistory(HttpServletRequest req, HttpServletResponse resp, User user)
            throws ServletException, IOException {
        List<Result> results = new ArrayList<>(resultDao.findByUserId(user.getId()));
        results.sort(Comparator.comparing(Result::getDate).reversed());   // новые сверху

        // id теста -> название (для таблицы)
        Map<UUID, String> titles = new HashMap<>();
        for (Result r : results) {
            if (!titles.containsKey(r.getTestId())) {
                Optional<Test> t = testDao.findById(r.getTestId());
                t.ifPresent(x -> titles.put(x.getId(), x.getTitle()));
            }
        }

        req.setAttribute("results", results);
        req.setAttribute("titles", titles);
        req.getRequestDispatcher("/WEB-INF/views/results.jsp").forward(req, resp);
    }

    // GET /results/{id} : подробности одного результата
    private void showDetails(HttpServletRequest req, HttpServletResponse resp, User user, String idPart)
            throws ServletException, IOException {
        UUID id;
        try {
            id = UUID.fromString(idPart);
        } catch (IllegalArgumentException e) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        Optional<Result> optionalResult = resultDao.findById(id);
        if (optionalResult.isEmpty()) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        Result result = optionalResult.get();

        // Чужой результат видит только админ. Для остальных он "не существует".
        boolean own = result.getUserId().equals(user.getId());
        if (!own && user.getRole() != Role.ADMIN) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        Optional<Test> optionalTest = testDao.findById(result.getTestId());
        if (optionalTest.isEmpty()) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);   // тест удалили
            return;
        }
        Test test = optionalTest.get();

        List<ReviewItem> review = new ArrayList<>();
        for (AnswerResult ar : result.getAnswers()) {
            Question q = test.getQuestions().stream()
                    .filter(x -> x.getId().equals(ar.getQuestionId()))
                    .findFirst()
                    .orElse(null);
            if (q == null) {
                continue;   // вопрос убрали из теста после прохождения
            }

            String selectedText = null;
            String correctText = null;
            for (Answer a : q.getAnswers()) {
                if (a.getId().equals(ar.getSelectedAnswerId())) {
                    selectedText = a.getText();
                }
                if (a.isCorrect()) {
                    correctText = a.getText();
                }
            }
            review.add(new ReviewItem(q.getText(), selectedText, correctText, ar.isCorrect()));
        }

        req.setAttribute("result", result);
        req.setAttribute("test", test);
        req.setAttribute("review", review);
        req.getRequestDispatcher("/WEB-INF/views/result.jsp").forward(req, resp);
    }
}

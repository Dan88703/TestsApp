package backend.servlet;

import backend.dao.ResultDao;
import backend.dao.TestDao;
import backend.dto.TestStat;
import backend.entity.Result;
import backend.entity.Test;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.*;

@WebServlet("/admin/stats")
public class AdminStatsServlet extends HttpServlet {
    private TestDao testDao;
    private ResultDao resultDao;

    @Override
    public void init() {
        testDao = (TestDao) getServletContext().getAttribute("testDao");
        resultDao = (ResultDao) getServletContext().getAttribute("resultDao");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<Result> results = resultDao.findAll();


        Map<UUID, List<Result>> byTest = new HashMap<>();
        for (Result r : results) {
            byTest.computeIfAbsent(r.getTestId(), k -> new ArrayList<>()).add(r);
        }

        List<TestStat> stats = new ArrayList<>();
        for (Test t : testDao.findAll()) {
            List<Result> list = byTest.getOrDefault(t.getId(), List.of());

            int sum = 0;
            int best = 0;
            for (Result r : list) {
                int percent = r.getTotal() == 0 ? 0 : r.getScore() * 100 / r.getTotal();
                sum += percent;
                best = Math.max(best, percent);
            }
            int avg = list.isEmpty() ? 0 : sum / list.size();

            stats.add(new TestStat(t.getTitle(), list.size(), avg, best));
        }

        req.setAttribute("stats", stats);
        req.setAttribute("totalAttempts", results.size());
        req.getRequestDispatcher("/WEB-INF/views/stats.jsp").forward(req, resp);
    }
}

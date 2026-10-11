package backend.servlet;

import backend.dao.ResultDao;
import backend.dao.TestDao;
import backend.entity.Result;
import backend.entity.User;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.HashSet;
import java.util.Set;
import java.util.UUID;

@WebServlet(urlPatterns = "/main")
public class MainServlet extends HttpServlet {
    private TestDao dao;
    private ResultDao resultDao;
    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        resultDao = (ResultDao) getServletContext().getAttribute("resultDao");
        dao = (TestDao) config.getServletContext().getAttribute("testDao");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");

        Set<UUID> doneIds = new HashSet<>();
        for (Result r : resultDao.findByUserId(user.getId())) {
            doneIds.add(r.getTestId());
        }
        req.setAttribute("doneIds", doneIds);
        req.setAttribute("tests", dao.findAll());
        req.getRequestDispatcher("/WEB-INF/views/main.jsp").forward(req, resp);
    }
}

package backend.servlet;

import backend.dao.TestDao;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(urlPatterns = "/main")
public class MainServlet extends HttpServlet {
    private TestDao dao;
    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        dao = (TestDao) config.getServletContext().getAttribute("testDao");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("tests", dao.findAll());
        req.getRequestDispatcher("/WEB-INF/views/main.jsp").forward(req, resp);
    }
}

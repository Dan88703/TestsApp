package backend.servlet;

import backend.dao.TestDao;
import backend.entity.Test;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Optional;
import java.util.UUID;

@WebServlet(urlPatterns = "/tests/*")
public class TestServlet extends HttpServlet {
    private TestDao dao;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        dao = (TestDao) config.getServletContext().getAttribute("testDao");
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
}

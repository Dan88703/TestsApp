package backend.servlet;

import backend.entity.User;
import backend.service.UserService;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import java.io.IOException;
import java.util.Optional;

@WebServlet(urlPatterns = "/login")
public class LoginServlet extends HttpServlet {

    private UserService userService;
    private BCryptPasswordEncoder encoder;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);

        userService = (UserService) config.getServletContext().getAttribute("userService");
        encoder = (BCryptPasswordEncoder) config.getServletContext().getAttribute("encoder");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/login.html").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String name = req.getParameter("name");
        String pas = req.getParameter("password");

        Optional<User> optionalUser = userService.findByUsername(name, pas);

        if (optionalUser.isPresent()) {
            req.getSession().setAttribute("user", optionalUser.get());
            req.getRequestDispatcher("/main.jsp").forward(req, resp);

        } else {
            req.getRequestDispatcher("/reg.html").forward(req, resp);
        }

    }
}

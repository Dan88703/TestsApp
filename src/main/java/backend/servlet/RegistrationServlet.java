package backend.servlet;

import backend.dao.UserDao;
import backend.entity.User;
import backend.service.UserService;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.var;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import java.io.IOException;
import java.util.Optional;
import java.util.UUID;

@WebServlet(urlPatterns = "/reg")
public class RegistrationServlet extends HttpServlet {
    private UserService userService;
    private BCryptPasswordEncoder bCryptPasswordEncoder;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        userService = (UserService) config.getServletContext().getAttribute("userService");
        bCryptPasswordEncoder = (BCryptPasswordEncoder) config.getServletContext().getAttribute("encoder");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/reg.html").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String name = req.getParameter("name");
        String pas = req.getParameter("password");
        User user = User.builder()
                .id(UUID.randomUUID())
                .name(name)
                .password(bCryptPasswordEncoder.encode(pas))
                .build();

        boolean completed = userService.save(user);

        if (completed) {
            Optional<User> optionalUser = userService.findByUsername(name, pas);
            if (optionalUser.isPresent()) {
                req.getSession().setAttribute("user", optionalUser.get());
                req.getRequestDispatcher("/main.jsp").forward(req, resp);
            } else {
                resp.sendRedirect(req.getContextPath() + "/reg");
            }
        } else {
            req.setAttribute("error", "Не удалось зарегистрировать пользователя");
            req.getRequestDispatcher("/reg.html").forward(req, resp);
        }

    }
}

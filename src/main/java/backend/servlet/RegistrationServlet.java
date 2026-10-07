package backend.servlet;

import backend.entity.User;
import backend.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import java.io.IOException;
import java.util.UUID;

@WebServlet(urlPatterns = "/reg")
public class RegistrationServlet extends HttpServlet {

    private UserService userService;
    private BCryptPasswordEncoder bCryptPasswordEncoder;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("reg.jsp").forward(req, resp);
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

        userService.save(user);
    }
}

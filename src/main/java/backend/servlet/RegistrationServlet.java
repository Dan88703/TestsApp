package backend.servlet;

import backend.entity.Role;
import backend.entity.User;
import backend.service.UserService;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
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
        req.getRequestDispatcher("/WEB-INF/views/reg.jsp").forward(req, resp);
    }

    private void forwardWithError(HttpServletRequest req, HttpServletResponse resp, String msg)
            throws ServletException, IOException {
        req.setAttribute("error", msg);
        req.getRequestDispatcher("/WEB-INF/views/reg.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String name = req.getParameter("name");
        String pas = req.getParameter("password");
        if (name == null || pas == null) {
            forwardWithError(req, resp, "Error: name or password is empty");
            return;
        }
        name = name.trim();
        if (name.length() < 3 || name.length() > 30) {
            forwardWithError(req, resp, "Error: name is too short");
            return;
        }
        if (pas.length() < 8 || pas.getBytes(StandardCharsets.UTF_8).length > 72) {
            forwardWithError(req, resp, "Password mast be between 8 and 72 characters");
            return;
        }
        User user = User.builder()
                .id(UUID.randomUUID())
                .name(name)
                .password(bCryptPasswordEncoder.encode(pas))
                .role(Role.USER)
                .build();

        boolean completed = userService.save(user);
        if (completed) {
            HttpSession session = req.getSession();
            req.changeSessionId();
            session.setAttribute("user", user.toBuilder().password(null).build());
            resp.sendRedirect(req.getContextPath() + "/main");
        } else {
            forwardWithError(req, resp, "this name already exist");
        }

    }
}

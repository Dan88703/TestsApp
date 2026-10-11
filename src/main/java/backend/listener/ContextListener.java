package backend.listener;

import backend.dao.TestDao;
import backend.dao.UserDao;
import backend.service.UserService;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import java.io.File;
@WebListener
public class ContextListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce){
    ServletContext servletContext = sce.getServletContext();

        ObjectMapper mapper = new ObjectMapper();
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        File file = new File("D:\\TestsApp\\src\\main\\resources\\data\\users\\users.json");
        File testsDir = new File("D:\\TestsApp\\src\\main\\resources\\data\\tests");
        TestDao testDao = new TestDao(mapper, testsDir);
        servletContext.setAttribute("testDao", testDao);
        UserDao dao = new UserDao(mapper,file);
        UserService service = new UserService(dao,encoder);
        servletContext.setAttribute("encoder", encoder);
        servletContext.setAttribute("userService", service);
    }
}

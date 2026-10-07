package backend.listener;

import backend.dao.UserDao;
import backend.service.UserService;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import java.io.File;

public class ContextListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce){
    ServletContext servletContext = sce.getServletContext();

        ObjectMapper mapper = new ObjectMapper();
        BCryptPasswordEncoder bCryptPasswordEncoder = new BCryptPasswordEncoder();
        File file = new File("D:\\TestsApp\\src\\main\\resources\\data\\users\\users.json");
        UserDao dao = new UserDao(mapper,file);
        UserService service = new UserService(dao,bCryptPasswordEncoder);
        servletContext.setAttribute("encoder", bCryptPasswordEncoder);
        servletContext.setAttribute("userService", service);
    }
}

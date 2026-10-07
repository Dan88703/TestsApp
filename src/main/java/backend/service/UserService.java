package backend.service;

import backend.dao.UserDao;
import backend.entity.User;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

@RequiredArgsConstructor
public class UserService {
    private final UserDao userDao;
    private final BCryptPasswordEncoder passwordEncoder;

    public boolean save(User user) {
        return userDao.save(user);
    }

    public Optional<User> findByUsername(String username, String password) throws IOException {
        List<User> users = userDao.find();

        return users.stream()
                .filter(e -> e.getName().equals(username) && passwordEncoder.matches(password, e.getPassword()))
                .findFirst();
    }

}

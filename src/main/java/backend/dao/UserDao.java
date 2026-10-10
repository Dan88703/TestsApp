package backend.dao;

import backend.entity.User;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.SneakyThrows;

import java.io.File;
import java.io.IOException;
import java.util.List;

@RequiredArgsConstructor
public class UserDao {

    private final ObjectMapper mapper;
    private final File file;

    @SneakyThrows
    public synchronized boolean save(User user) {
        try {
            List<User> list = find();

            boolean exists = list.stream()
                    .anyMatch(u -> u.getName() != null && u.getName().equalsIgnoreCase(user.getName()));

            if (exists) {
                return false;
            }

            list.add(user);
            mapper.writeValue(file, list);
            return true;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }

    public synchronized List<User> find() throws IOException {
        return mapper.readValue(file, new TypeReference<List<User>>() {
        });
    }
}

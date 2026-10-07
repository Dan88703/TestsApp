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
    public void save(User user) {
        List<User> list = find();
        list.add(user);
        mapper.writeValue(file, list);
    }

    public List<User> find() throws IOException {
        return mapper.readValue(file, new TypeReference<List<User>>() {
        });
    }
}

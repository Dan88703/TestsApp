package backend.dao;

import backend.entity.Test;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.SneakyThrows;

import java.io.File;
import java.io.IOException;
import java.util.*;

@RequiredArgsConstructor
public class TestDao {
    private final ObjectMapper mapper;
    private final File dir;

    private File fileOf(UUID id) {
        return new File(dir, "test" + id + ".json");
    }

    @SneakyThrows
    public synchronized void save(Test test) throws IOException {
        dir.mkdirs();
        mapper.writeValue(fileOf(test.getId()), test);
    }

    public synchronized Optional<Test> findById(UUID id) throws IOException {
        File f = fileOf(id);
        if (!f.exists()) {
            return Optional.empty();
        }
        return Optional.of(mapper.readValue(f, Test.class));
    }

    public synchronized List<Test> findAll() throws IOException {
        File[] files = dir.listFiles((d, name) -> name.endsWith(".json"));
        List<Test> tests = new ArrayList<>();
        if (files == null) {
            return new ArrayList<>();
        }
        for  (File f : files) {
            Test test = mapper.readValue(f, Test.class);
            tests.add(test);
        }
        return tests;
    }

    public synchronized boolean delete(UUID id) {
        return fileOf(id).delete();
    }
}

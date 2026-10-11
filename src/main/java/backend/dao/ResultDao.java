package backend.dao;

import backend.entity.Result;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

@RequiredArgsConstructor
public class ResultDao {
    private final ObjectMapper mapper;
    private final File file;

    public synchronized void save(Result result) throws IOException {
        List<Result> list = findAll();
        list.add(result);
        mapper.writeValue(file, list);
    }

    public synchronized List<Result> findAll() throws IOException {
        if (!file.exists() || file.length() == 0) {
            return new ArrayList<>();
        }
        return mapper.readValue(file, new TypeReference<List<Result>>() {});
    }

    public synchronized List<Result> findByUserId(UUID userId) throws IOException {
        return findAll().stream()
                .filter(r -> userId.equals(r.getUserId()))
                .collect(Collectors.toList());
    }

    public synchronized Optional<Result> findById(UUID id) throws IOException {
        return findAll().stream()
                .filter(r -> id.equals(r.getId()))
                .findFirst();
    }
}

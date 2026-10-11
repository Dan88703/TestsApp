package backend.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Data
@Builder(toBuilder = true)
@AllArgsConstructor
@NoArgsConstructor
public class Test {
    private UUID id;
    private String title;
    private String topic;
    private UUID createdBy;
    @Builder.Default
    private List<Question> questions = new ArrayList<>();
}

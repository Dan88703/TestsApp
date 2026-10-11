package backend.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Data
@Builder(toBuilder = true)
@AllArgsConstructor
@NoArgsConstructor
public class Result {
    private UUID id;
    private UUID userId;
    private UUID testId;
    private LocalDateTime date;
    private int score;
    private int total;
    private List<AnswerResult> answers;
}

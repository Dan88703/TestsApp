package backend.entity;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Data
@Builder(toBuilder = true)
@AllArgsConstructor
@NoArgsConstructor
public class AnswerResult {
    private UUID questionId;
    private UUID selectedAnswerId;
    @JsonProperty("isCorrect")
    private boolean correct;
}

package backend.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class TestStat {
    private String title;
    private int attempts;
    private int avgPercent;
    private int bestPercent;
}

package backend.dto;


import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class ReviewItem {
    private String questionText;
    private String selectedText;   // null, если не отвечено
    private String correctText;
    private boolean correct;
}
# TestsApp

A web application for taking tests, built with Java Servlets and JSP. It has two roles:

- **ADMIN** creates, edits and deletes tests and questions, and views statistics.
- **USER** takes tests and views results and attempt history.

Data is stored in JSON files, so no database is required.

## Features

**Everyone**
- registration and login (passwords are stored as BCrypt hashes), logout
- page protection: guests are redirected to `/login`

**User (USER)**
- list of tests, with a "Completed" badge on tests already taken
- taking a test with a timer (1 minute per question; when time runs out the test is submitted automatically)
- result page with a breakdown of answers
- personal attempt history ("My results")

**Administrator (ADMIN)**
- create a test (title and topic)
- edit the title and topic
- add a question (2 to 4 answers, one correct) and delete a question
- delete a test (with confirmation)
- statistics: number of attempts, average and best result per test

## Tech stack

| What | Used |
|---|---|
| Language | Java |
| Web | Jakarta Servlet 6, JSP, JSTL 3 |
| Server | Apache Tomcat 10.1 |
| Build | Maven (WAR) |
| JSON | Jackson (+ `jackson-datatype-jsr310`) |
| Passwords | BCrypt (Spring Security Crypto) |
| Other | Lombok |

## Project structure

```
src/main/java/backend/
  entity/     User, Role, Test, Question, Answer, Result, AnswerResult
  dto/        ReviewItem, TestStat
  dao/        UserDao, TestDao, ResultDao (read and write JSON)
  service/    UserService
  filter/     AuthFilter (login and role checks)
  servlet/    Login, Registration, Logout, Main, Test, AdminTest, Result, AdminStats
  listener/   ContextListener (creates the DAOs and stores them in the context)

src/main/webapp/WEB-INF/
  views/      login, reg, main, test, results, result, edit, stats (.jsp)
  web.xml

data/
  users/users.json
  tests/test<uuid>.json      (one file per test)
  results/results.json
```

## Data storage

- `users.json` is an array of users (`id`, `name`, `password` as a hash, `role`)
- `tests/test<uuid>.json` is one file per test, with its questions and answers inside
- `results.json` is an array of results (`userId`, `testId`, `score`, `total`, answers)

DAO methods are `synchronized` so concurrent requests cannot corrupt the files.

## Running the app

1. Install a JDK, Maven and Tomcat 10.1.
2. Open the project in IntelliJ IDEA.
3. Check the data paths in `ContextListener`. They are currently
   `D:\TestsApp\src\main\resources\data\...`; change them to match your machine.
4. Create a **Tomcat Server → Local** run configuration and deploy the `TestsApp:war exploded` artifact.
5. Start it and open `http://localhost:8080/` (the context path depends on your deployment settings).

> Run it from the Tomcat configuration, not with `mvn deploy`.

### Creating an administrator

Registration only creates the `USER` role. To make an admin:

1. Register a user.
2. Open `users.json` and change that user's `"role"` to `"ADMIN"`.
3. Log out and log in again, because the role is stored in the session at login.

## Routes

| Method | Path | Who | What it does |
|---|---|---|---|
| GET/POST | `/login` | everyone | log in |
| GET/POST | `/reg` | everyone | register |
| POST | `/logout` | logged in | log out |
| GET | `/main` | logged in | list of tests |
| GET | `/tests/{id}` | logged in | test page |
| POST | `/tests/{id}/submit` | logged in | submit answers, score, save the result |
| GET | `/results` | logged in | attempt history |
| GET | `/results/{id}` | logged in | breakdown of one attempt |
| POST | `/tests` | ADMIN | create a test |
| GET | `/admin/tests/{id}` | ADMIN | edit page |
| POST | `/admin/tests/{id}/update` | ADMIN | change title and topic |
| POST | `/admin/tests/{id}/delete` | ADMIN | delete a test |
| POST | `/admin/tests/{id}/questions` | ADMIN | add a question |
| POST | `/admin/tests/{id}/questions/{qid}/delete` | ADMIN | delete a question |
| GET | `/admin/stats` | ADMIN | statistics |

## Security

- **Permissions are enforced on the server** in `AuthFilter`. Hiding buttons with CSS is only cosmetic. A regular user who opens `/admin/...` gets a 403.
- Passwords are stored as BCrypt hashes; length is limited to 72 bytes (the BCrypt limit).
- The session ID is changed after login (`changeSessionId`) to prevent session fixation.
- The current user is taken from the session, not from a form, so a `userId` cannot be forged in a request.
- A failed login always shows the same message, "Invalid name or password", so it does not reveal whether a name exists.
- Output in JSP is escaped with `<c:out>`.

## Deviations and limitations

- `POST /update` and `POST /delete` are used instead of `PUT` and `DELETE`, because HTML forms only support GET and POST.
- The timer runs only in the browser; the server does not check the time.
- File storage is fine for a learning project but not for heavy load.
- There is no CSRF protection.

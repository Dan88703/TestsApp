<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Edit: <c:out value="${test.title}"/></title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Onest:wght@400;500;600&family=Unbounded:wght@500&display=swap"
          rel="stylesheet">
    <style>
        :root {
            --ink: #14213d;
            --ink-soft: #5b6784;
            --cobalt: #3446f0;
            --cobalt-deep: #2535c4;
            --sky: #dfe6fb;
            --line: #d5dbee;
            --coral: #ff6f4e;
            --error: #d6361f;
            --ok: #1f9d6b;
            --radius: 14px;
            --font-display: "Unbounded", "Arial Black", sans-serif;
            --font-body: "Onest", system-ui, -apple-system, "Segoe UI", sans-serif;
        }

        *, *::before, *::after {
            box-sizing: border-box;
        }

        html, body {
            margin: 0;
        }

        body {
            min-height: 100vh;
            padding: 24px;
            font-family: var(--font-body);
            color: var(--ink);
            background: var(--sky);
            position: relative;
            overflow-x: hidden;
            -webkit-font-smoothing: antialiased;
        }

        body::before,
        body::after {
            content: "";
            position: fixed;
            border-radius: 50%;
            pointer-events: none;
        }

        body::before {
            width: 520px;
            height: 520px;
            left: -180px;
            bottom: -220px;
            background: var(--cobalt);
        }

        body::after {
            width: 120px;
            height: 120px;
            right: 12%;
            top: 14%;
            background: var(--coral);
        }

        .page {
            position: relative;
            z-index: 1;
            width: 100%;
            max-width: 760px;
            margin: 0 auto;
            display: grid;
            gap: 20px;
        }

        .card {
            background: #fff;
            border-radius: 24px;
            padding: clamp(20px, 5vw, 32px);
            box-shadow: 0 30px 60px -30px rgba(20, 33, 61, .35);
        }

        .card h1 {
            font-family: var(--font-display);
            font-weight: 500;
            font-size: 1.5rem;
            letter-spacing: -.02em;
            margin: 0 0 6px;
        }

        .card h2 {
            font-family: var(--font-display);
            font-weight: 500;
            font-size: 1.1rem;
            letter-spacing: -.02em;
            margin: 0 0 18px;
        }

        .head p {
            margin: 0;
            color: var(--ink-soft);
            font-size: .95rem;
        }

        .head a {
            color: var(--cobalt);
            font-weight: 500;
        }

        /* Формы */
        .form {
            display: grid;
            gap: 16px;
        }

        .field {
            display: grid;
            gap: 6px;
        }

        .field__label {
            font-size: .9rem;
            font-weight: 500;
        }

        .field__input {
            width: 100%;
            height: 48px;
            padding: 0 16px;
            border: 1.5px solid var(--line);
            border-radius: var(--radius);
            background: #fafbff;
            color: var(--ink);
            font: 400 1rem var(--font-body);
            transition: border-color .15s, box-shadow .15s, background-color .15s;
        }

        .field__input::placeholder {
            color: #9aa3bb;
        }

        .field__input:hover {
            border-color: #aab4d4;
        }

        .field__input:focus {
            outline: none;
            background: #fff;
            border-color: var(--cobalt);
            box-shadow: 0 0 0 4px rgba(52, 70, 240, .16);
        }

        .form__error {
            margin: 0 0 16px;
            padding: 12px 16px;
            border-radius: var(--radius);
            background: #fdecea;
            color: var(--error);
            font-size: .88rem;
        }

        /* Строка варианта ответа: переключатель "правильный" + текст */
        .answer-row {
            display: grid;
            grid-template-columns: 22px 1fr;
            gap: 14px;
            align-items: center;
        }

        .answer-row input[type="radio"] {
            appearance: none;
            -webkit-appearance: none;
            width: 22px;
            height: 22px;
            margin: 0;
            border: 1.5px solid var(--line);
            border-radius: 50%;
            background: #fff;
            cursor: pointer;
            transition: border-color .15s, box-shadow .15s;
        }

        .answer-row input[type="radio"]:checked {
            border-color: var(--ok);
            box-shadow: inset 0 0 0 5px var(--ok);
        }

        .answer-row input[type="radio"]:focus-visible {
            outline: 3px solid var(--ink);
            outline-offset: 3px;
        }

        .hint {
            margin: 0;
            color: var(--ink-soft);
            font-size: .85rem;
        }

        /* Вопросы */
        .question__head {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 16px;
            margin-bottom: 12px;
        }

        .question__title {
            margin: 0;
            font-size: 1.05rem;
            font-weight: 600;
        }

        .answers {
            list-style: none;
            margin: 0;
            padding: 0;
            display: grid;
            gap: 8px;
        }

        .answers li {
            padding: 10px 14px;
            border: 1.5px solid var(--line);
            border-radius: var(--radius);
            background: #fafbff;
            font-size: .95rem;
        }

        .answers li.is-correct {
            border-color: var(--ok);
            background: #e9f7f1;
        }

        .answers .tag {
            margin-left: 8px;
            color: var(--ok);
            font-size: .8rem;
            font-weight: 600;
        }

        .empty {
            margin: 0;
            padding: 12px;
            text-align: center;
            color: var(--ink-soft);
        }

        /* Кнопки */
        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            height: 44px;
            padding: 0 22px;
            border: 0;
            border-radius: var(--radius);
            font: 600 .95rem var(--font-body);
            cursor: pointer;
            transition: background-color .15s, transform .1s;
        }

        .btn:active {
            transform: translateY(1px);
        }

        .btn:focus-visible {
            outline: 3px solid var(--ink);
            outline-offset: 3px;
        }

        .btn-primary {
            background: var(--cobalt);
            color: #fff;
        }

        .btn-primary:hover {
            background: var(--cobalt-deep);
        }

        .btn-ghost {
            background: transparent;
            color: var(--error);
            border: 1.5px solid var(--line);
        }

        .btn-ghost:hover {
            border-color: var(--error);
        }

        .btn-small {
            height: 36px;
            padding: 0 16px;
            font-size: .85rem;
        }

        @media (max-width: 520px) {
            body {
                padding: 16px;
            }

            body::before {
                width: 360px;
                height: 360px;
                left: -160px;
                bottom: -170px;
            }

            body::after {
                width: 80px;
                height: 80px;
            }
        }

        @media (prefers-reduced-motion: reduce) {
            * {
                transition: none !important;
            }
        }
    </style>
</head>
<body>
<div class="page">

    <header class="card head">
        <h1><c:out value="${test.title}"/></h1>
        <p><c:out value="${test.topic}"/> · ${test.questions.size()} questions</p>
        <a href="${pageContext.request.contextPath}/main">Back to tests</a>
    </header>

    <section class="card">
        <h2>Test details</h2>
        <c:if test="${param.error == 'details'}">
            <p class="form__error" role="alert">Title (up to 100 characters) and topic (up to 50) are required.</p>
        </c:if>
        <form class="form" method="post" action="${pageContext.request.contextPath}/admin/tests/${test.id}/update">
            <div class="field">
                <label class="field__label" for="title">Title</label>
                <input class="field__input" id="title" name="title" type="text" maxlength="100" required
                       value="<c:out value='${test.title}'/>">
            </div>
            <div class="field">
                <label class="field__label" for="topic">Topic</label>
                <input class="field__input" id="topic" name="topic" type="text" maxlength="50" required
                       value="<c:out value='${test.topic}'/>">
            </div>
            <button class="btn btn-primary" type="submit">Save changes</button>
        </form>
    </section>

    <c:forEach items="${test.questions}" var="q" varStatus="st">
        <section class="card">
            <div class="question__head">
                <h3 class="question__title">${st.count}. <c:out value="${q.text}"/></h3>
                <form method="post"
                      action="${pageContext.request.contextPath}/admin/tests/${test.id}/questions/${q.id}/delete"
                      onsubmit="return confirm('Delete this question?');">
                    <button class="btn btn-ghost btn-small" type="submit">Delete question</button>
                </form>
            </div>
            <ul class="answers">
                <c:forEach items="${q.answers}" var="a">
                    <li class="${a.correct ? 'is-correct' : ''}">
                        <c:out value="${a.text}"/>
                        <c:if test="${a.correct}"><span class="tag">Correct</span></c:if>
                    </li>
                </c:forEach>
            </ul>
        </section>
    </c:forEach>

    <c:if test="${empty test.questions}">
        <section class="card">
            <p class="empty">No questions yet. Add the first one below.</p>
        </section>
    </c:if>

    <section class="card">
        <h2>Add question</h2>
        <c:if test="${param.error == 'question'}">
            <p class="form__error" role="alert">A question needs text, at least two answers, and one answer marked as
                correct.</p>
        </c:if>
        <form class="form" method="post" action="${pageContext.request.contextPath}/admin/tests/${test.id}/questions">
            <div class="field">
                <label class="field__label" for="text">Question</label>
                <input class="field__input" id="text" name="text" type="text" maxlength="300" required
                       placeholder="What is Java?">
            </div>

            <p class="hint">Fill in 2 to 4 answers and select the correct one.</p>

            <div class="answer-row">
                <input type="radio" name="correct" value="1" required aria-label="Answer 1 is correct">
                <input class="field__input" name="answer1" type="text" maxlength="200" required placeholder="Answer 1">
            </div>
            <div class="answer-row">
                <input type="radio" name="correct" value="2" aria-label="Answer 2 is correct">
                <input class="field__input" name="answer2" type="text" maxlength="200" required placeholder="Answer 2">
            </div>
            <div class="answer-row">
                <input type="radio" name="correct" value="3" aria-label="Answer 3 is correct">
                <input class="field__input" name="answer3" type="text" maxlength="200"
                       placeholder="Answer 3 (optional)">
            </div>
            <div class="answer-row">
                <input type="radio" name="correct" value="4" aria-label="Answer 4 is correct">
                <input class="field__input" name="answer4" type="text" maxlength="200"
                       placeholder="Answer 4 (optional)">
            </div>

            <button class="btn btn-primary" type="submit">Add question</button>
        </form>
    </section>

    <section class="card">
        <h2>Delete test</h2>
        <p class="hint" style="margin-bottom: 16px;">This removes the test and its questions. Past results stay in
            history.</p>
        <form method="post"
              action="${pageContext.request.contextPath}/admin/tests/${test.id}/delete"
              onsubmit="return confirm('Delete this test? This cannot be undone.');">
            <button class="btn btn-ghost" type="submit">Delete test</button>
        </form>
    </section>

</div>
</body>
</html>
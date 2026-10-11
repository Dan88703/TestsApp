<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><c:out value="${test.title}"/></title>
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

        /* Шапка теста */
        .head h1 {
            font-family: var(--font-display);
            font-weight: 500;
            font-size: 1.5rem;
            letter-spacing: -.02em;
            margin: 0 0 6px;
        }

        .head p {
            margin: 0 0 14px;
            color: var(--ink-soft);
            font-size: .95rem;
        }

        .head a {
            color: var(--cobalt);
            font-weight: 500;
        }

        /* Место под таймер: заполняй своей логикой */
        .timer {
            display: none;
            margin-top: 12px;
            font-weight: 600;
            color: var(--coral);
        }

        .timer.is-visible {
            display: block;
        }

        /* Вопрос */
        .question {
            border: 0;
            margin: 0;
            padding: 0;
            min-width: 0;
        }

        .question legend {
            padding: 0;
            margin: 0 0 16px;
            font-size: 1.05rem;
            font-weight: 600;
        }

        /* Вариант ответа */
        .option {
            display: grid;
            grid-template-columns: 22px 1fr;
            gap: 14px;
            align-items: center;
            padding: 14px 18px;
            border: 1.5px solid var(--line);
            border-radius: var(--radius);
            background: #fafbff;
            cursor: pointer;
            transition: border-color .15s, background-color .15s;
        }

        .option + .option {
            margin-top: 10px;
        }

        .option:hover {
            border-color: #aab4d4;
        }

        .option:has(input:checked) {
            border-color: var(--cobalt);
            background: #f0f2ff;
        }

        .option input {
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

        .option input:checked {
            border-color: var(--cobalt);
            box-shadow: inset 0 0 0 5px var(--cobalt);
        }

        .option input:focus-visible {
            outline: 3px solid var(--ink);
            outline-offset: 3px;
        }

        .btn-primary {
            height: 52px;
            border: 0;
            border-radius: var(--radius);
            background: var(--cobalt);
            color: #fff;
            font: 600 1rem var(--font-body);
            cursor: pointer;
            transition: background-color .15s, transform .1s;
        }

        .btn-primary:hover {
            background: var(--cobalt-deep);
        }

        .btn-primary:active {
            transform: translateY(1px);
        }

        .btn-primary:focus-visible {
            outline: 3px solid var(--ink);
            outline-offset: 3px;
        }

        .btn-primary:disabled {
            background: #aab3ee;
            cursor: not-allowed;
        }

        .empty {
            margin: 0;
            padding: 28px;
            text-align: center;
            color: var(--ink-soft);
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
        <div class="timer" id="timer" data-seconds="${test.questions.size() * 60}"></div>
    </header>

    <c:if test="${empty test.questions}">
        <section class="card">
            <p class="empty">This test has no questions yet.</p>
        </section>
    </c:if>

    <c:if test="${not empty test.questions}">
        <form class="page" id="quiz" method="post" action="${pageContext.request.contextPath}/tests/${test.id}/submit">

            <c:forEach items="${test.questions}" var="q" varStatus="st">
                <section class="card">
                    <fieldset class="question">
                        <legend>${st.count}. <c:out value="${q.text}"/></legend>

                        <c:forEach items="${q.answers}" var="a" varStatus="ast">
                            <label class="option">
                                <input type="radio" name="q-${q.id}" value="${a.id}" ${ast.first ? 'required' : ''}>
                                <span><c:out value="${a.text}"/></span>
                            </label>
                        </c:forEach>
                    </fieldset>
                </section>
            </c:forEach>

            <button class="btn-primary" type="submit">Finish test</button>
        </form>
    </c:if>

</div>
<script>
    (function () {
        var timerEl = document.getElementById('timer');
        var form = document.getElementById('quiz');
        if (!timerEl || !form) return;

        var seconds = parseInt(timerEl.dataset.seconds, 10);
        var deadline = Date.now() + seconds * 1000;
        var id;

        function render() {
            var left = Math.max(0, Math.round((deadline - Date.now()) / 1000));
            var min = Math.floor(left / 60);
            var sec = String(left % 60).padStart(2, '0');
            timerEl.textContent = 'Time left: ' + min + ':' + sec;

            if (left <= 0) {
                clearInterval(id);
                form.submit();
            }
        }

        timerEl.classList.add('is-visible');
        id = setInterval(render, 500);
        render();

        form.addEventListener('submit', function () {
            clearInterval(id);
        });
    })();
</script>
</body>
</html>
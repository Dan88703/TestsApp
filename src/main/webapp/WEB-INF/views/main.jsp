<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Tests</title>
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

        /* Два круга на фоне — единственное украшение */
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

        /* Шапка */
        .top {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            flex-wrap: wrap;
            background: #fff;
            border-radius: 24px;
            padding: 20px 28px;
            box-shadow: 0 30px 60px -30px rgba(20, 33, 61, .35);
        }

        .top h1 {
            font-family: var(--font-display);
            font-weight: 500;
            font-size: 1.5rem;
            letter-spacing: -.02em;
            margin: 0;
        }

        .top__user {
            display: flex;
            align-items: center;
            gap: 16px;
            color: var(--ink-soft);
            font-size: .95rem;
        }

        .top__user a {
            color: var(--cobalt);
            font-weight: 500;
        }

        /* Общая карточка */
        .card {
            background: #fff;
            border-radius: 24px;
            padding: clamp(20px, 5vw, 32px);
            box-shadow: 0 30px 60px -30px rgba(20, 33, 61, .35);
        }

        .card h2 {
            font-family: var(--font-display);
            font-weight: 500;
            font-size: 1.1rem;
            letter-spacing: -.02em;
            margin: 0 0 18px;
        }

        body:not(.is-admin) .admin-only {
            display: none;
        }

        /* Форма */
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

        textarea.field__input {
            height: auto;
            min-height: 96px;
            padding: 12px 16px;
            resize: vertical;
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

        .field__error {
            display: none;
            margin: 0;
            font-size: .82rem;
            color: var(--error);
        }

        .field.is-error .field__input {
            border-color: var(--error);
        }

        .field.is-error .field__error {
            display: block;
        }

        .field.is-valid .field__input {
            border-color: var(--ok);
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
            text-decoration: none;
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

        .btn-primary:disabled {
            background: #aab3ee;
            cursor: not-allowed;
        }

        .btn-ghost {
            background: transparent;
            color: var(--error);
            border: 1.5px solid var(--line);
        }

        .btn-ghost:hover {
            border-color: var(--error);
        }

        .form .btn-primary {
            height: 52px;
        }

        /* Список тестов */
        .tests {
            list-style: none;
            margin: 0;
            padding: 0;
            display: grid;
            gap: 14px;
        }

        .test {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
            padding: 20px 22px;
            border: 1.5px solid var(--line);
            border-radius: 18px;
            background: #fafbff;
            transition: border-color .15s;
        }

        .test:hover {
            border-color: #aab4d4;
        }

        .test__info {
            min-width: 0;
        }

        .test__title {
            margin: 0 0 4px;
            font-size: 1.05rem;
            font-weight: 600;
        }

        .test__desc {
            margin: 0 0 8px;
            color: var(--ink-soft);
            font-size: .92rem;
        }

        .test__meta {
            margin: 0;
            color: var(--ink-soft);
            font-size: .82rem;
        }

        /* Статус «пройден» — класс is-done на .test */
        .test__badge {
            display: none;
            margin-left: 8px;
            padding: 2px 10px;
            border-radius: 999px;
            background: #e3f6ee;
            color: var(--ok);
            font-size: .78rem;
            font-weight: 500;
        }

        .test.is-done {
            border-color: var(--ok);
        }

        .test.is-done .test__badge {
            display: inline-block;
        }

        .test__actions {
            display: flex;
            gap: 10px;
            flex-shrink: 0;
        }

        /* Пустой список */
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

            .test {
                flex-direction: column;
                align-items: stretch;
            }

            .test__actions .btn {
                flex: 1;
            }
        }

        @media (prefers-reduced-motion: reduce) {
            * {
                transition: none !important;
            }
        }
    </style>
</head>
<body class="${sessionScope.user.role == 'ADMIN' ? 'is-admin' : ''}">
<div class="page">
    <header class="top">
        <span>Tests found: ${tests.size()}</span>
        <h1>Tests</h1>
        <a href="${pageContext.request.contextPath}/results">My results</a>
        <div class="top__user">
            <span>Hi, <c:out value="${sessionScope.user.name}"/></span>
            <form action="${pageContext.request.contextPath}/logout" method="post">
                <button class="btn btn-ghost" type="submit">Log out</button>
            </form>
        </div>
    </header>
    <section class="card admin-only">
        <h2>New test</h2>
        <form class="form" method="post" action="${pageContext.request.contextPath}/tests">
            <div class="field">
                <label class="field__label" for="title">Title</label>
                <input class="field__input" id="title" name="title" type="text" maxlength="100" required
                       placeholder="For example, Java Basics">
            </div>

            <div class="field">
                <label class="field__label" for="topic">Topic</label>
                <input class="field__input" id="topic" name="topic" type="text" maxlength="50" required
                       placeholder="For example, Programming">
            </div>

            <button class="btn btn-primary" type="submit">Add test</button>
        </form>
    </section>

    <section class="card">
        <h2>Available tests</h2>

        <c:if test="${empty tests}">
            <p class="empty">No tests yet.</p>
        </c:if>

        <ul class="tests">
            <c:forEach items="${tests}" var="t">
                <li class="test ${doneIds.contains(t.id) ? 'is-done' : ''}">
                    <div class="test__info">
                        <h3 class="test__title"><c:out value="${t.title}"/><span class="test__badge">Completed</span>
                        </h3>
                        <p class="test__desc"><c:out value="${t.topic}"/></p>
                        <p class="test__meta">${t.questions.size()} questions</p>
                    </div>
                    <div class="test__actions">
                        <a class="btn btn-primary" href="${pageContext.request.contextPath}/tests/${t.id}">Take test</a>
                        <a class="btn btn-ghost admin-only"
                           href="${pageContext.request.contextPath}/admin/tests/${t.id}">Edit</a>
                        <form class="admin-only" method="post"
                              action="${pageContext.request.contextPath}/admin/tests/${t.id}/delete"
                              onsubmit="return confirm('Delete this test? This cannot be undone.');">
                            <button class="btn btn-ghost" type="submit">Delete</button>
                        </form>
                    </div>
                </li>
            </c:forEach>
        </ul>
    </section>

</div>
</body>
</html>
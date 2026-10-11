<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Sign up</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Onest:wght@400;500;600&family=Unbounded:wght@500&display=swap" rel="stylesheet">
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

        *, *::before, *::after { box-sizing: border-box; }
        html, body { margin: 0; }

        body {
            min-height: 100vh;
            display: grid;
            place-items: center;
            padding: 24px;
            font-family: var(--font-body);
            color: var(--ink);
            background: var(--sky);
            position: relative;
            overflow-x: hidden;
            -webkit-font-smoothing: antialiased;
        }

        /* Two circles in the background: the only decoration */
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

        .card {
            position: relative;
            z-index: 1;
            width: 100%;
            max-width: 400px;
            background: #fff;
            border-radius: 24px;
            padding: clamp(28px, 6vw, 44px);
            box-shadow: 0 30px 60px -30px rgba(20, 33, 61, .35);
        }

        .card h1 {
            font-family: var(--font-display);
            font-weight: 500;
            font-size: 1.6rem;
            letter-spacing: -.02em;
            margin: 0 0 6px;
        }
        .card__sub {
            margin: 0 0 28px;
            color: var(--ink-soft);
            font-size: .95rem;
        }
        .card__sub a { color: var(--cobalt); font-weight: 500; }

        .form { display: grid; gap: 18px; }

        .field { display: grid; gap: 6px; }
        .field__label { font-size: .9rem; font-weight: 500; }

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
        .field__input::placeholder { color: #9aa3bb; }
        .field__input:hover { border-color: #aab4d4; }
        .field__input:focus {
            outline: none;
            background: #fff;
            border-color: var(--cobalt);
            box-shadow: 0 0 0 4px rgba(52, 70, 240, .16);
        }

        /* States for your logic: add a class to .field */
        .field__error {
            display: none;
            margin: 0;
            font-size: .82rem;
            color: var(--error);
        }
        .field.is-error .field__input { border-color: var(--error); }
        .field.is-error .field__input:focus { box-shadow: 0 0 0 4px rgba(214, 54, 31, .16); }
        .field.is-error .field__error { display: block; }
        .field.is-valid .field__input { border-color: var(--ok); }

        /* General error from the server: rendered only when there is one */
        .form__error {
            margin: 0;
            padding: 12px 16px;
            border-radius: var(--radius);
            background: #fdecea;
            color: var(--error);
            font-size: .88rem;
        }

        .btn-primary {
            height: 52px;
            margin-top: 6px;
            border: 0;
            border-radius: var(--radius);
            background: var(--cobalt);
            color: #fff;
            font: 600 1rem var(--font-body);
            cursor: pointer;
            transition: background-color .15s, transform .1s;
        }
        .btn-primary:hover { background: var(--cobalt-deep); }
        .btn-primary:active { transform: translateY(1px); }
        .btn-primary:focus-visible {
            outline: 3px solid var(--ink);
            outline-offset: 3px;
        }
        .btn-primary:disabled {
            background: #aab3ee;
            cursor: not-allowed;
        }

        @media (max-width: 520px) {
            body::before { width: 360px; height: 360px; left: -160px; bottom: -170px; }
            body::after  { width: 80px; height: 80px; }
        }
        @media (prefers-reduced-motion: reduce) {
            * { transition: none !important; }
        }
    </style>
</head>
<body>
<main class="card">
    <h1>Sign up</h1>
    <p class="card__sub">Already have an account? <a href="${pageContext.request.contextPath}/login">Log in</a></p>

    <form class="form" method="post" action="${pageContext.request.contextPath}/reg" novalidate>
        <c:if test="${not empty error}">
            <p class="form__error" role="alert"><c:out value="${error}"/></p>
        </c:if>

        <div class="field">
            <label class="field__label" for="name">Name</label>
            <input class="field__input" id="name" name="name" type="text" placeholder="3 to 30 characters" autocomplete="username">
            <p class="field__error">Enter your name</p>
        </div>

        <div class="field">
            <label class="field__label" for="password">Password</label>
            <input class="field__input" id="password" name="password" type="password" placeholder="At least 8 characters" autocomplete="new-password">
            <p class="field__error">Password is too short</p>
        </div>

        <button class="btn-primary" type="submit">Sign up</button>
    </form>
</main>
</body>
</html>
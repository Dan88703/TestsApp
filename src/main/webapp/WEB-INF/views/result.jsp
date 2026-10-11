<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>My results</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Onest:wght@400;500;600&family=Unbounded:wght@500&display=swap" rel="stylesheet">
    <style>
        :root {
            --ink: #14213d;
            --ink-soft: #5b6784;
            --cobalt: #3446f0;
            --sky: #dfe6fb;
            --line: #d5dbee;
            --coral: #ff6f4e;
            --font-display: "Unbounded", "Arial Black", sans-serif;
            --font-body: "Onest", system-ui, -apple-system, "Segoe UI", sans-serif;
        }

        *, *::before, *::after { box-sizing: border-box; }
        html, body { margin: 0; }

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
        .head h1 {
            font-family: var(--font-display);
            font-weight: 500;
            font-size: 1.5rem;
            letter-spacing: -.02em;
            margin: 0 0 10px;
        }
        .head a, .table a { color: var(--cobalt); font-weight: 500; }

        .table-wrap { overflow-x: auto; }
        .table { width: 100%; border-collapse: collapse; font-size: .95rem; }
        .table th, .table td {
            padding: 14px 12px;
            text-align: left;
            border-bottom: 1px solid var(--line);
            white-space: nowrap;
        }
        .table th { font-weight: 600; color: var(--ink-soft); font-size: .85rem; }
        .table tbody tr:last-child td { border-bottom: 0; }

        .empty { margin: 0; padding: 28px; text-align: center; color: var(--ink-soft); }

        @media (max-width: 520px) {
            body { padding: 16px; }
            body::before { width: 360px; height: 360px; left: -160px; bottom: -170px; }
            body::after  { width: 80px; height: 80px; }
        }
    </style>
</head>
<body>
<div class="page">

    <header class="card head">
        <h1>My results</h1>
        <a href="${pageContext.request.contextPath}/main">Back to tests</a>
    </header>

    <section class="card">
        <c:if test="${empty results}">
            <p class="empty">You haven't taken any tests yet.</p>
        </c:if>

        <c:if test="${not empty results}">
            <div class="table-wrap">
                <table class="table">
                    <thead>
                    <tr>
                        <th>Test</th>
                        <th>Score</th>
                        <th>Date</th>
                        <th></th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${results}" var="r">
                        <tr>
                            <td><c:out value="${empty titles[r.testId] ? 'Deleted test' : titles[r.testId]}"/></td>
                            <td>${r.score} / ${r.total}</td>
                            <td>${r.date.toString().substring(0, 16).replace('T', ' ')}</td>
                            <td><a href="${pageContext.request.contextPath}/results/${r.id}">Details</a></td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:if>
    </section>

</div>
</body>
</html>
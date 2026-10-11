<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Statistics</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Onest:wght@400;500;600&family=Unbounded:wght@500&display=swap"
          rel="stylesheet">
    <style>
        :root {
            --ink: #14213d;
            --ink-soft: #5b6784;
            --cobalt: #3446f0;
            --sky: #dfe6fb;
            --line: #d5dbee;
            --coral: #ff6f4e;
            --ok: #1f9d6b;
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

        body::before, body::after {
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

        .card p {
            margin: 0;
            color: var(--ink-soft);
            font-size: .95rem;
        }

        .card a {
            color: var(--cobalt);
            font-weight: 500;
        }

        .table-wrap {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            font-size: .95rem;
        }

        th, td {
            padding: 12px 10px;
            text-align: left;
            border-bottom: 1.5px solid var(--line);
        }

        th {
            color: var(--ink-soft);
            font-size: .8rem;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: .04em;
        }

        td.num, th.num {
            text-align: right;
            white-space: nowrap;
        }

        tr:last-child td {
            border-bottom: 0;
        }

        .best {
            color: var(--ok);
            font-weight: 600;
        }

        .empty {
            padding: 20px;
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
    </style>
</head>
<body>
<div class="page">

    <header class="card">
        <h1>Statistics</h1>
        <p>Total attempts: ${totalAttempts}</p>
        <a href="${pageContext.request.contextPath}/main">Back to tests</a>
    </header>

    <section class="card">
        <c:if test="${empty stats}">
            <p class="empty">No tests yet.</p>
        </c:if>

        <c:if test="${not empty stats}">
            <div class="table-wrap">
                <table>
                    <thead>
                    <tr>
                        <th>Test</th>
                        <th class="num">Attempts</th>
                        <th class="num">Average</th>
                        <th class="num">Best</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${stats}" var="s">
                        <tr>
                            <td><c:out value="${s.title}"/></td>
                            <td class="num">${s.attempts}</td>
                            <td class="num"><c:choose><c:when
                                    test="${s.attempts == 0}">—</c:when><c:otherwise>${s.avgPercent}%</c:otherwise></c:choose></td>
                            <td class="num best"><c:choose><c:when
                                    test="${s.attempts == 0}">—</c:when><c:otherwise>${s.bestPercent}%</c:otherwise></c:choose></td>
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
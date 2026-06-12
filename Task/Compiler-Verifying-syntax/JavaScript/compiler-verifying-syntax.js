// Regular expressions for validation
const re1 = /[^_a-zA-Z0-9\+\-\*/=<\(\)\s]/;
const re2 = /\b_\w*\b/;
const re3 = /[=<+*/-]\s*not/;
const re4 = /(=|<)\s*[^(=< ]+\s*([=<+*/-])/;

// Substitution patterns
const subs = [
    ["=", "=="],
    [" not ", " ! "],
    ["(not ", "(! "],
    [" or ", " || "],
    [" and ", " && "]
];

function possiblyValid(expr) {
    const matches1 = expr.match(re1);
    if (matches1) {
        throw new Error(`invalid character "${matches1[0]}" found`);
    }

    if (re2.test(expr)) {
        throw new Error("identifier cannot begin with an underscore");
    }

    if (re3.test(expr)) {
        throw new Error("expected operand, found 'not'");
    }

    const matches4 = expr.match(re4);
    if (matches4) {
        throw new Error(`operator "${matches4[1]}" is non-associative`);
    }

    return null;
}

function modify(err) {
    let e = err.message;
    for (const sub of subs) {
        e = e.replaceAll(sub[1].trim(), sub[0].trim());
    }
    // Remove location info as may be inaccurate
    const parts = e.split(":");
    return parts.length > 2 ? parts[2].substring(1) : e;
}

// Simple expression parser to mimic Go's parser.ParseExpr
function parseExpression(expr) {
    try {
        // This is a simplified parser - in a real implementation you'd want a proper parser
        // For now, we'll use eval in a safe context to check basic syntax
        const safeExpr = expr
            .replace(/\b[a-zA-Z_][a-zA-Z0-9_]*\b/g, 'true') // replace identifiers with 'true'
            .replace(/\b\d+\b/g, '1'); // replace numbers with '1'

        // Check for basic syntax errors
        if (expr.includes('++') || expr.includes('&')) {
            throw new Error("unexpected token");
        }

        // Check for unmatched parentheses
        let parenCount = 0;
        for (const char of expr) {
            if (char === '(') parenCount++;
            if (char === ')') parenCount--;
            if (parenCount < 0) throw new Error("unexpected ')'");
        }
        if (parenCount > 0) throw new Error("expected ')'");

        // Check for invalid sequences like "235 76"
        if (/\b\d+\s+\d+\b/.test(expr)) {
            throw new Error("unexpected number");
        }

        // Try to evaluate the safe expression
        new Function(`return ${safeExpr}`)();
        return null;
    } catch (error) {
        throw new Error(error.message);
    }
}

function main() {
    const exprs = [
        "$",
        "one",
        "either or both",
        "a + 1",
        "a + b < c",
        "a = b",
        "a or b = c",
        "3 + not 5",
        "3 + (not 5)",
        "(42 + 3",
        "(42 + 3)",
        " not 3 < 4 or (true or 3 /  4 + 8 *  5 - 5 * 2 < 56) and 4 * 3  < 12 or not true",
        " and 3 < 2",
        "not 7 < 2",
        "2 < 3 < 4",
        "2 < (3 < 4)",
        "2 < foobar - 3 < 4",
        "2 < foobar and 3 < 4",
        "4 * (32 - 16) + 9 = 73",
        "235 76 + 1",
        "true or false = not true",
        "true or false = (not true)",
        "not true or false = false",
        "not true = false",
        "a + b = not c and false",
        "a + b = (not c) and false",
        "a + b = (not c and false)",
        "ab_c / bd2 or < e_f7",
        "g not = h",
        "été = false",
        "i++",
        "j & k",
        "l or _m"
    ];

    for (const expr of exprs) {
        console.log(`Statement to verify: "${expr}"`);

        try {
            possiblyValid(expr);
        } catch (err) {
            console.log(`"false" -> ${err.message}\n`);
            continue;
        }

        let modifiedExpr = ` ${expr} `; // make sure there are spaces at both ends
        for (const sub of subs) {
            modifiedExpr = modifiedExpr.replaceAll(sub[0], sub[1]);
        }

        try {
            parseExpression(modifiedExpr);
            console.log('"true"');
        } catch (err) {
            console.log(`"false" -> ${modify(err)}`);
        }
        console.log();
    }
}

// Run the main function
main();

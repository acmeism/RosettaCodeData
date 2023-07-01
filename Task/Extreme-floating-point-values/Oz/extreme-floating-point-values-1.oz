declare
Inf = 1.0e234 * 1.0e234
MinusInf = 1.0e234 * ~1.0e234
Zero = 1.0 / Inf
MinusZero = 1.0 / MinusInf
NaN = 0.0 / 0.0

{System.showInfo "infinite: "#Inf}
{System.showInfo "-infinite: "#MinusInf}
{System.showInfo "0: "#Zero}
{System.showInfo "-0: "#MinusZero}  %% seems to be identical to Zero
{System.showInfo "NaN: "#NaN}

{System.showInfo "inf + -inf: "#Inf+MinusInf}
{System.showInfo "NaN * 0: "#NaN*0.0}
{System.showInfo "0 * NaN: "#0.0*NaN}
{System.showInfo "inf * 0: "#Inf*0.0}
{System.showInfo "0 * inf: "#0.0*Inf}

{Show NaN == NaN}  %% shows 'true' !
{Show Zero == MinusZero}

{Show 1.0/0.0 == Inf} %% true
{Show 1.0/~0.0 == MinusInf} %% true

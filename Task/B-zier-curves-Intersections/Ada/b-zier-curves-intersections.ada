pragma wide_character_encoding (utf8);
pragma ada_2022;
pragma assertion_policy (check);

--
-- The algorithm here is iterated "Bézier clipping" [1] of quadratic
-- Bézier curves in a plane. However, the curves will be represented
-- in the s-power basis [2,3], and there will be these other
-- differences from the algorithms suggested by [1]:
--
-- * Before clipping, the problem will be moved to a coordinate system
--   in which the "skeleton" of the clipper curve—the line segment
--   between its endpoints—extends from (0,0) and (1,0). In this
--   coordinate system, the "distance function" is the y-coordinate.
--
-- * The fat line will be the best possible parallel to the "skeleton"
--   of the clipper curve. This is easily done in the s-power basis,
--   once one has transformed coordinate systems as described above:
--   the center coefficient of the (y,t)-polynomial is exactly four
--   times the optimum signed fat line width.
--
-- * Intersections with fat line boundaries will be found not by
--   extending the sides of control polygons, but instead by the
--   quadratic formula.
--
-- * Mechanisms to ensure termination of the algorithm, and to improve
--   the chances of finding intersections, may differ.
--
-- Inputs and outputs to the algorithms will be in single
-- precision. However, the internals will be in double precision. This
-- decision helps resolve some minor numerical quandaries.
--
-- References:
--
-- [1] Sederberg, Thomas W., "Computer Aided Geometric Design"
--     (2012). Faculty
--     Publications. 1. https://scholarsarchive.byu.edu/facpub/1
--     http://hdl.lib.byu.edu/1877/2822
--
-- [2] J. Sánchez-Reyes, ‘The symmetric analogue of the polynomial
--     power basis’, ACM Transactions on Graphics, vol 16 no 3, July
--     1997, page 319.
--
-- [3] J. Sánchez-Reyes, ‘Applications of the polynomial s-power basis
--     in geometry processing’, ACM Transactions on Graphics, vol 19
--     no 1, January 2000, page 35.
--
-- Suggestions for the future:
--
-- * Combination of Bézier clipping and flatness testing. Remember
--   from other Rosetta Code examples, that in the s-power basis it is
--   simple to test the "flatness" of a parametric plane
--   curve. Suppose two curves are running nearly parallel to each
--   other, so they are difficult to reduce by clipping. Nevertheless,
--   they can be made flatter and flatter, so eventually they become
--   "segment-like" and can be tested by a line-intersection routine.
--

with ada.text_io;
use ada.text_io;

with ada.float_text_io;
use ada.float_text_io;

with ada.numerics.elementary_functions;
use ada.numerics.elementary_functions;

with ada.numerics.long_elementary_functions;
use ada.numerics.long_elementary_functions;

with ada.unchecked_deallocation;

procedure bezier_intersections is

  subtype real is float;
  subtype lreal is long_float;

  function between_0_and_1 (x : real)
  return boolean is
  begin
    return 0.0 <= x and x <= 1.0;
  end between_0_and_1;

  function between_0_and_1 (x : lreal)
  return boolean is
  begin
    return 0.0 <= x and x <= 1.0;
  end between_0_and_1;

  procedure quadratic_formula (a, b, c     : lreal;
                               has_smaller : out boolean;
                               smaller     : out lreal;
                               has_larger  : out boolean;
                               larger      : out lreal)
  with post => has_smaller or not has_larger
  is
    --
    -- This routine is based on QUADPL from the Naval Surface Warfare
    -- Center mathematical library nswc.f90 https://archive.ph/2IpWb
    --
    -- We are interested only in real roots. Be aware that, if there
    -- are two roots, they might be a double root.
    --

    bh, e, d        : lreal;

    -- Avogadro’s number, by definition (since 2019):
    arbitrary_value : constant lreal := 6.012214076e23;
  begin
    has_smaller := false;
    has_larger := false;
    smaller := arbitrary_value;
    larger := arbitrary_value;

    if a = 0.0 then
      if b = 0.0 then
        -- The equation is a constant equation. I do not know what to
        -- do with that. There may be no solution, or there may be
        -- infinitely many solutions. Let us treat it as having no
        -- USEFUL solutions.
        null;
      else
        -- The equation is linear. There truly is only one root.
        has_smaller := true;
        smaller := -c / b;
      end if;
    elsif c = 0.0 then
      -- The equation is quadratic, but the constant term
      -- vanishes. One of the roots is trivially zero.
      has_smaller := true;
      has_larger := true;
      smaller := 0.0;
      larger := -b / a;
    else
      -- Compute the discriminant, avoiding overflow.
      bh := b / 2.0;
      if abs (bh) >= abs (c) then
        e := 1.0 - (a / bh) * (c / bh);
        d := sqrt (abs (e)) * abs(bh);
      else
        e := (if c < 0.0 then -a else a);
        e := bh * (bh / abs (c)) - e;
        d := sqrt (abs (e)) * sqrt (abs (c));
      end if;
      if e < 0.0 then
        -- The solutions are complex conjugates, but we are interested
        -- only in real solutions.
        null;
      else
        has_smaller := true;
        has_larger := true;
        if bh >= 0.0 then
          d := -d;
        end if;
        larger := (-bh + d) / a;
        if larger = 0.0 then
          smaller := 0.0;       -- Obviously a double root.
        else
          smaller := (c / larger) / a;
        end if;
      end if;
    end if;
  end quadratic_formula;

  type point is
    record
      x, y : real;
    end record;

  type control_point_curve is
    record
      pt0, pt1, pt2 : point;
    end record;

  type spower_poly is
    record
      c0, c1, c2 : real;
    end record;

  type spower_curve is
    record
      x, y : spower_poly;
    end record;

  function eval (poly : spower_poly;
                 t    : real)
  return real is
    c0, c1, c2 : real;
  begin
    c0 := poly.c0;
    c1 := poly.c1;
    c2 := poly.c2;
    return (if t <= 0.5 then
              c0 + t * ((c2 - c0) + ((1.0 - t) * c1))
            else
              c2 + (1.0 - t) * ((c0 - c2) + (t * c1)));
  end eval;

  function eval (curve : spower_curve;
                 t     : real)
  return point is
  begin
    return (x => eval (curve.x, t),
            y => eval (curve.y, t));
  end eval;

  function to_spower_curve (ctrl : control_point_curve)
  return spower_curve is
    curve    : spower_curve;
    p0x, p0y : long_float;
    p1x, p1y : long_float;
    p2x, p2y : long_float;
  begin
    curve.x.c0 := ctrl.pt0.x;
    curve.y.c0 := ctrl.pt0.y;

    curve.x.c2 := ctrl.pt2.x;
    curve.y.c2 := ctrl.pt2.y;

    p0x := long_float (ctrl.pt0.x);
    p0y := long_float (ctrl.pt0.y);
    p1x := long_float (ctrl.pt1.x);
    p1y := long_float (ctrl.pt1.y);
    p2x := long_float (ctrl.pt2.x);
    p2y := long_float (ctrl.pt2.y);
    curve.x.c1 := float (p1x + p1x - p0x - p2x);
    curve.y.c1 := float (p1y + p1y - p0y - p2y);

    return curve;
  end to_spower_curve;

  type opoint is
    record
      -- A point relative to the origin.
      x, y : lreal;
    end record;

  type dpoint is
    record
      -- A point relative to some other point.
      dx, dy : lreal;
    end record;

  function "-" (pt1, pt2 : opoint)
  return dpoint is
  begin
    return (dx => pt1.x - pt2.x,
            dy => pt1.y - pt2.y);
  end "-";

  function "+" (opt : opoint;
                dpt : dpoint)
  return opoint is
  begin
    return (x => opt.x + dpt.dx,
            y => opt.y + dpt.dy);
  end "+";

  function "+" (pt1, pt2 : dpoint)
  return dpoint is
  begin
    return (dx => pt1.dx + pt2.dx,
            dy => pt1.dy + pt2.dy);
  end "+";

  function "*" (scalar : lreal;
                pt     : dpoint)
  return dpoint is
  begin
    return (dx => scalar * pt.dx,
            dy => scalar * pt.dy);
  end "*";

  type geocurve is
    record
      --
      -- A plane curve in s-power basis, represented geometrically.
      --
      -- pt0 and pt2 form the curve’s ‘skeleton’. Their convex combination,
      -- ((1.0-t)*pt0)+(t*pt1), form the linear backbone of the curve.
      --
      -- (1.0-t)*t*pt1 forms (x,t) and (y,t) parabolas that are
      -- convex-up/down, and which (because this is an s-power curve)
      -- vanish as the curve becomes linear.
      --
      -- The actual geocurve is the locus of (1.0-t)*t*pt1 relative to
      -- the skeleton, respectively for each value of t in [0,1].
      --
      -- If [t0,t1] is not [0.0,1.0], then this is a portion of some
      -- parent curve that is determined by context.
      --
      -- (I feel as if all this can be crafted nicely in terms of a
      -- geometric algebra, with special points not only at infinity
      -- but also at the origin, but let us not worry about that for
      -- now. Likely the calculations would not change much, but the
      -- names of things might.)
      --
      pt0    : opoint;
      pt1    : dpoint;
      pt2    : opoint;
      t0, t1 : lreal;
    end record;

  function to_geocurve (scurve : spower_curve)
  return geocurve is
    gcurve : geocurve;
  begin
    gcurve.pt0.x := lreal (scurve.x.c0);
    gcurve.pt0.y := lreal (scurve.y.c0);
    gcurve.pt1.dx := lreal (scurve.x.c1);
    gcurve.pt1.dy := lreal (scurve.y.c1);
    gcurve.pt2.x := lreal (scurve.x.c2);
    gcurve.pt2.y := lreal (scurve.y.c2);
    gcurve.t0 := 0.0;
    gcurve.t1 := 1.0;
    return gcurve;
  end to_geocurve;

  function eval (gcurve : geocurve;
                 t      : lreal)
  return opoint is
    pt0 : opoint;
    pt1 : dpoint;
    pt2 : opoint;
  begin
    pt0 := gcurve.pt0;
    pt1 := gcurve.pt1;
    pt2 := gcurve.pt2;
    return (if t <= 0.5 then
              pt0 + t * ((pt2 - pt0) + ((1.0 - t) * pt1))
            else
              pt2 + (1.0 - t) * ((pt0 - pt2) + (t * pt1)));
  end eval;

  type affine_projection is
    record
      --
      -- An affine transformation used to project objects into the
      -- coordinate system of what we are calling a "skeleton".
      --
      -- If it is an opoint, first add transpose[dx,dy]. If it is a
      -- dpoint, ignore dx,dy. Then, in either case, premultiply by
      -- [[a,b],[c,d]]. (One can view dx,dy as a dpoint.)
      --
      dx, dy : lreal;
      a, b   : lreal;
      c, d   : lreal;
    end record;

  function project (pt    : opoint;
                    trans : affine_projection)
  return opoint is
    x, y : lreal;
  begin
    -- Apply an affine transformation to an opoint, projecting it from
    -- one coordinate system to another.
    x := pt.x + trans.dx;       -- The origin may have moved.
    y := pt.y + trans.dy;
    return (x => trans.a * x + trans.b * y, -- Rotation, scaling, etc.
            y => trans.c * x + trans.d * y);
  end project;

  function project (pt    : dpoint;
                    trans : affine_projection)
  return dpoint is
    x, y : lreal;
  begin
    -- Apply an affine transformation to a dpoint, projecting it from
    -- one coordinate system to another.
    x := pt.dx;          -- With dpoint, translation is not performed.
    y := pt.dy;
    return (dx => trans.a * x + trans.b * y, -- Rotation, scaling, &c.
            dy => trans.c * x + trans.d * y);
  end project;

  function project (gcurve : geocurve;
                    trans  : affine_projection)
  return geocurve is
  begin
    -- Apply an affine transformation to a geocurve, projecting it
    -- from one coordinate system to another.
    return (pt0 => project (gcurve.pt0, trans),
            pt1 => project (gcurve.pt1, trans),
            pt2 => project (gcurve.pt2, trans),
            t0 => 0.0, t1 => 1.0);
  end project;

  function segment_projection_to_0_1 (pt0, pt1 : opoint)
  return affine_projection is
    a, b  : lreal;
    denom : lreal;
  begin
    -- Return the transformation that projects pt0 to (0,0) and pt1 to
    -- (1,0) without any distortions except translation, rotation, and
    -- scaling.
    a := pt1.x - pt0.x;
    b := pt1.y - pt0.y;
    denom := (a * a) + (b * b);
    pragma assert (denom /= 0.0);
    a := a / denom;
    b := b / denom;
    return (dx => -pt0.x, dy => -pt0.y,
            a => a,  b => b,
            c => -b, d => a);
  end segment_projection_to_0_1;

  procedure test_segment_projection_to_0_1 is
    trans : affine_projection;
    pt    : opoint;
  begin
    -- Some unit testing.

    trans := segment_projection_to_0_1 ((1.0, 2.0), (-3.0, 5.0));
    pt := project ((1.0, 2.0), trans);
    pragma assert (abs (pt.x) < 1.0e-10);
    pragma assert (abs (pt.y) < 1.0e-10);
    pt := project ((-3.0, 5.0), trans);
    pragma assert (abs (pt.x - 1.0) < 1.0e-10);
    pragma assert (abs (pt.y) < 1.0e-10);

    trans := segment_projection_to_0_1 ((0.0, 2.0), (0.0, -50.0));
    pt := project ((0.0, 2.0), trans);
    pragma assert (abs (pt.x) < 1.0e-10);
    pragma assert (abs (pt.y) < 1.0e-10);
    pt := project ((0.0, -50.0), trans);
    pragma assert (abs (pt.x - 1.0) < 1.0e-10);
    pragma assert (abs (pt.y) < 1.0e-10);
  end test_segment_projection_to_0_1;

  function skeleton_projection (clipper : geocurve)
  return affine_projection is
  begin
    -- Return the transformation that projects the "skeleton" of the
    -- clipper into a coordinate system where the skeleton goes from
    -- the origin (0,0) to the point (1,0).
    return segment_projection_to_0_1 (clipper.pt0, clipper.pt2);
  end skeleton_projection;

  procedure fat_line_bounds (projected_clipper : geocurve;
                             dmin, dmax        : out lreal) is
    d       : lreal;
    d1, d2  : lreal;
    padding : constant lreal := lreal (real'model_epsilon) / 1000.0;
  begin
    --
    -- (1-t)*t is bounded on [0,1] by 0 and 1/4. Thus we have our fat
    -- line boundaries. We leave some padding, however, for numerical
    -- safety. The padding is much smaller than our tolerance. (We are
    -- calculating in double precision, but to obtain results in
    -- single precision.)
    --
    -- The fat line bounds will be y=dmin and y=dmax. If you ignore
    -- the padding, the fat line is the best possible among those
    -- parallel to the skeleton. It is likely to be much tighter than
    -- what you would infer from the Bernstein-basis control polygon.
    --

    d := projected_clipper.pt1.dy / 4.0;
    d1 := -padding * d;
    d2 := (1.0 + padding) * d;
    dmin := lreal'min (d1, d2);
    dmax := lreal'max (d1, d2);
  end fat_line_bounds;

  type clipping_places is
    (clip_everywhere,
     clip_nowhere,
     clip_left_and_right);

  type clipping_plan is
    record
      where  : clipping_places;
      t_lft  : lreal;
      t_rgt  : lreal;
    end record;

  function make_clipping_plan (projected_clippehend : geocurve;
                               dmin, dmax           : lreal)
  return clipping_plan is
    ncrossings  : integer range 0 .. 4;
    tcrossings  : array (1 .. 4) of lreal;
    dcrossings  : array (1 .. 4) of lreal;
    has_smaller : boolean;
    has_larger  : boolean;
    smaller     : lreal;
    larger      : lreal;
    c0, c1, c2  : lreal;

    function outside_of_bounds
    return boolean is
      dy, ymin, ymax : lreal;
    begin
      -- (1-t)*t is bounded on [0,1] by 0 and 1/4. Use that fact to
      -- make padding for a simple (although not especially tight)
      -- bounds on y.
      dy := abs (projected_clippehend.pt1.dy) / 4.0;
      ymin := -dy + lreal'min (projected_clippehend.pt0.y,
                               projected_clippehend.pt2.y);
      ymax := dy + lreal'max (projected_clippehend.pt0.y,
                              projected_clippehend.pt2.y);
      return (ymax <= dmin or dmax <= ymin);
    end outside_of_bounds;

    procedure find_crossings (yvalue : lreal) is
    begin
      quadratic_formula (-c1, c1 + c2 - c0, c0 - yvalue,
                         has_smaller, smaller, has_larger, larger);
      if has_smaller then
        if between_0_and_1 (smaller) then
          ncrossings := ncrossings + 1;
          tcrossings(ncrossings) := smaller;
          dcrossings(ncrossings) := yvalue;
        end if;
      end if;
      if has_larger then
        if between_0_and_1 (larger) then
          ncrossings := ncrossings + 1;
          tcrossings(ncrossings) := larger;
          dcrossings(ncrossings) := yvalue;
        end if;
      end if;
    end find_crossings;

    function create_a_clipping_plan
    return clipping_plan is
      plan : clipping_plan;
    begin
      --
      -- For simplicity, there is just one situation in which we will
      -- clip: when there is one crossing of dmin and one crossing of
      -- dmax.
      --
      if ncrossings = 2 and then dcrossings(1) /= dcrossings(2) then
        plan.where := clip_left_and_right;
        plan.t_lft := lreal'min (tcrossings(1), tcrossings(2));
        plan.t_rgt := lreal'max (tcrossings(1), tcrossings(2));
      else
        plan.where := clip_nowhere;
        -- Arbitrary values:
        plan.t_lft := 0.0;
        plan.t_rgt := 0.0;
      end if;
      return plan;
    end create_a_clipping_plan;

    function analyze_and_plan
    return clipping_plan is
    begin
      c0 := projected_clippehend.pt0.y;
      c1 := projected_clippehend.pt1.dy;
      c2 := projected_clippehend.pt2.y;
      ncrossings := 0;
      find_crossings (dmin);
      find_crossings (dmax);
      return create_a_clipping_plan;
    end analyze_and_plan;

  begin
    return (if outside_of_bounds then
              (where => clip_everywhere,
               -- Arbitrary values:
               t_lft => 0.0, t_rgt => 0.0)
            else
              analyze_and_plan);
  end make_clipping_plan;

  function make_portion (gcurve : geocurve;
                         t0, t1 : lreal)
  return geocurve is
    pt0    : opoint;
    pt1    : dpoint;
    pt2    : opoint;
  begin
    --
    -- NOTE FOR THE FUTURE: This operation is a change of HOMOGENEOUS
    --                      coordinates. Here we are still using
    --                      regular euclidean coordinates, however.
    --
    pt0 := eval (gcurve, t0);
    pt1 := ((t1 - t0 - t0) * t1 + (t0 * t0)) * gcurve.pt1;
    pt2 := eval (gcurve, t1);
    return (pt0 => pt0, pt1 => pt1, pt2 => pt2,
            t0 => t0, t1 => t1);
  end make_portion;

  procedure segment_parameters (a0, a1 : opoint;
                                b0, b1 : opoint;
                                ta, tb : out lreal) is
    axdiff : lreal;
    aydiff : lreal;
    bxdiff : lreal;
    bydiff : lreal;
    denom  : lreal;
    ta1    : lreal;
    tb1    : lreal;
  begin
    -- Do the line segments (a0,a1) and (b0,b1) intersect?  If so,
    -- return t-parameter values in ta,tb in [0,1] for the point of
    -- intersection, treating them as parametric splines of degree
    -- 1. Otherwise return ta=-1.0 and tb=-1.0.

    ta := -1.0;
    tb := -1.0;

    axdiff := a1.x - a0.x;
    aydiff := a1.y - a0.y;
    bxdiff := b1.x - b0.x;
    bydiff := b1.y - b0.y;

    denom := (axdiff * bydiff) - (aydiff * bxdiff);

    ta1 := ((bxdiff * a0.y) - (bydiff * a0.x)
               + (b0.x * b1.y) - (b1.x * b0.y));
    ta1 := ta1 / denom;
    if between_0_and_1 (ta1) then
      tb1 := -((axdiff * b0.y) - (aydiff * b0.x)
                  + (a0.x * a1.y) - (a1.x * a0.y));
      tb1 := tb1 / denom;
      if between_0_and_1 (tb1) then
        ta := ta1;
        tb := tb1;
      end if;
    end if;
  end segment_parameters;

  type t_pair;
  type t_pair_access is access t_pair;
  type t_pair is
    record
      tp, tq : real;            -- Single precision results.
      next   : t_pair_access;
    end record;
  procedure t_pair_delete is
    new ada.unchecked_deallocation (t_pair, t_pair_access);

  function length (params : t_pair_access)
  return natural is
    n : natural;
    p : t_pair_access;
  begin
    n := 0;
    p := params;
    while p /= null loop
      n := n + 1;
      p := p.next;
    end loop;
    return n;
  end length;

  procedure insert_t_pair (params : in out t_pair_access;
                           tp, tq : real)
  with pre => between_0_and_1 (tp) and between_0_and_1 (tq)
  is
    pair : t_pair_access;
  begin
    -- Test for duplicates and also sort as we insert. This is a
    -- recursive implementation.
    if params = null then
      pair := new t_pair;
      params := pair;
      pair.next := null;
      pair.tp := tp;
      pair.tq := tq;
    elsif abs (params.tp - tp) <= real'model_epsilon then
      null;                     -- A duplicate, to within epsilon.
    elsif params.tp < tp then
      insert_t_pair (params.next, tp, tq);
    else
      pair := new t_pair;
      pair.next := params.next;
      params.next := pair;
      pair.tp := params.tp;
      pair.tq := params.tq;
      params.tp := tp;
      params.tq := tq;
    end if;
  end insert_t_pair;

  procedure insert_t_pair (params : in out t_pair_access;
                           tp, tq : lreal)
  with pre => between_0_and_1 (tp) and between_0_and_1 (tq)
  is
  begin
    insert_t_pair (params, real (tp), real (tq));
  end insert_t_pair;

  type clipping_roles is
    (pportion_clips_qportion,
     qportion_clips_pportion);

  type intersection_job;
  type intersection_job_access is access intersection_job;
  type intersection_job is
    record
      pportion : geocurve;
      qportion : geocurve;
      roles    : clipping_roles;
      next     : intersection_job_access;
    end record;
  procedure intersection_job_delete is
    new ada.unchecked_deallocation (intersection_job,
                                    intersection_job_access);

  function find_intersections (p, q : geocurve)
  return t_pair_access is
    params     : t_pair_access;
    workload   : intersection_job_access;
    pportion   : geocurve;
    qportion   : geocurve;
    roles      : clipping_roles;
    tp, tq     : lreal;

    tolerance : constant lreal := 0.4 * lreal (real'model_epsilon);
    bisection_threshold : constant lreal := 0.2;

    procedure insert_job (pportion : geocurve;
                          qportion : geocurve;
                          roles    : clipping_roles)
    with post => workload /= null
    is
      job : intersection_job_access;
    begin
      job := new intersection_job;
      job.pportion := pportion;
      job.qportion := qportion;
      job.roles := roles;
      job.next := workload;
      workload := job;
    end insert_job;

    procedure insert_job (pportion : geocurve;
                          qportion : geocurve)
    with post => workload /= null
    is
      roles : clipping_roles;
    begin
      if pportion.t1 - pportion.t0 <= qportion.t1 - qportion.t0 then
        roles := pportion_clips_qportion;
      else
        roles := qportion_clips_pportion;
      end if;
      insert_job (pportion, qportion, roles);
    end insert_job;

    procedure choose_job
    with pre => workload /= null
    is
      job : intersection_job_access;
    begin
      job := workload;
      workload := workload.next;
      pportion := job.pportion;
      qportion := job.qportion;
      roles := job.roles;
      intersection_job_delete (job);
    end choose_job;

    function t_parameters_are_within_tolerance
    return boolean is
    begin
      return (pportion.t1 - pportion.t0 <= tolerance
                and qportion.t1 - qportion.t0 <= tolerance);
    end t_parameters_are_within_tolerance;

    procedure insert_intersection_parameters is
    begin
      segment_parameters (pportion.pt0, pportion.pt2,
                          qportion.pt0, qportion.pt2, tp, tq);
      if between_0_and_1 (tp) and between_0_and_1 (tq) then
        tp := (1.0 - tp) * pportion.t0 + tp * pportion.t1;
        tq := (1.0 - tq) * qportion.t0 + tq * qportion.t1;
        insert_t_pair (params, tp, tq);
      end if;
    end insert_intersection_parameters;

  procedure no_intersections is
  begin
    -- Do nothing. The reason to have a procedure for this is so the
    -- code will document itself.
    null;
  end no_intersections;

  procedure bisect_them is
    pportion1  : geocurve;
    pportion2  : geocurve;
    qportion1  : geocurve;
    qportion2  : geocurve;
    t0, t1, th : lreal;
  begin
    --
    -- Sederberg employs heuristics to decide what to bisect and who
    -- should be the clipper. We will simply bisect both curves, and
    -- use some heuristic coded elsewhere to choose the
    -- clipper.
    --
    -- (Bisection as it is normally done in the s-power basis is
    -- equivalent to change of homogeneous coordinates. It can be
    -- applied to p and q directly and, for quadratics, is a simple
    -- operation.)
    --

    t0 := pportion.t0;
    t1 := pportion.t1;
    th := 0.5 * t0 + 0.5 * t1;
    pportion1 := make_portion (p, t0, th);
    pportion2 := make_portion (p, th, t1);

    t0 := qportion.t0;
    t1 := qportion.t1;
    th := 0.5 * t0 + 0.5 * t1;
    qportion1 := make_portion (q, t0, th);
    qportion2 := make_portion (q, th, t1);

    insert_job (pportion1, qportion1);
    insert_job (pportion1, qportion2);
    insert_job (pportion2, qportion1);
    insert_job (pportion2, qportion2);
  end bisect_them;

  procedure clip_and_maybe_bisect (plan : clipping_plan) is
    clipping : geocurve;
    t_lft    : lreal;
    t_rgt    : lreal;
    t0, t1   : lreal;
  begin
    t_lft := plan.t_lft;
    t_rgt := plan.t_rgt;
    if roles = pportion_clips_qportion then
      t0 := (1.0 - t_lft) * qportion.t0 + t_lft * qportion.t1;
      t1 := (1.0 - t_rgt) * qportion.t0 + t_rgt * qportion.t1;
      clipping := make_portion (q, t0, t1);
      if 1.0 - (t_rgt - t_lft) < bisection_threshold then
        qportion := clipping;
        bisect_them;
      else
        insert_job (pportion, clipping, qportion_clips_pportion);
      end if;
    else
      t0 := (1.0 - t_lft) * pportion.t0 + t_lft * pportion.t1;
      t1 := (1.0 - t_rgt) * pportion.t0 + t_rgt * pportion.t1;
      clipping := make_portion (p, t0, t1);
      if 1.0 - (t_rgt - t_lft) < bisection_threshold then
        pportion := clipping;
        bisect_them;
      else
        insert_job (clipping, qportion, pportion_clips_qportion);
      end if;
    end if;
  end clip_and_maybe_bisect;

  procedure perform_clipping is
    clippehend, clipper  : geocurve;
    projected_clippehend : geocurve;
    projected_clipper    : geocurve;
    trans                : affine_projection;
    dmin, dmax           : lreal;
    plan                 : clipping_plan;
  begin
    if roles = pportion_clips_qportion then
      clipper := pportion;
      clippehend := qportion;
    else
      clipper := qportion;
      clippehend := pportion;
    end if;
    trans := skeleton_projection (clipper);
    projected_clipper := project (clipper, trans);
    fat_line_bounds (projected_clipper, dmin, dmax);
    projected_clippehend := project (clippehend, trans);
    plan := make_clipping_plan (projected_clippehend, dmin, dmax);
    case plan.where is
      when clip_everywhere => no_intersections;
      when clip_nowhere => bisect_them;
      when clip_left_and_right => clip_and_maybe_bisect (plan);
    end case;
  end perform_clipping;

  begin
    params := null;
    workload := null;
    insert_job (p, q);
    while workload /= null loop
      choose_job;
      if t_parameters_are_within_tolerance then
        insert_intersection_parameters;
      else
        perform_clipping;
      end if;
    end loop;
    return params;
  end find_intersections;

  function find_intersections (p, q : spower_curve)
  return t_pair_access is
  begin
    return find_intersections (to_geocurve (p), to_geocurve (q));
  end find_intersections;

  pctrl, qctrl : control_point_curve;
  p, q         : spower_curve;
  params, ptr  : t_pair_access;

begin
  test_segment_projection_to_0_1;
  pctrl := ((x => -1.0, y =>  0.0),
            (x =>  0.0, y => 10.0),
            (x =>  1.0, y =>  0.0));
  qctrl := ((x =>  2.0, y =>  1.0),
            (x => -8.0, y =>  2.0),
            (x =>  2.0, y =>  3.0));
  p := to_spower_curve (pctrl);
  q := to_spower_curve (qctrl);
  params := find_intersections (p, q);

  set_col (to => 9);
  put ("convex up");
  set_col (to => 44);
  put_line ("convex left");
  ptr := params;
  while ptr /= null loop
    set_col (to => 3);
    put (ptr.tp, fore => 1, aft => 6, exp => 0);
    set_col (to => 13);
    put ("(");
    put (eval (p, ptr.tp).x, fore => 1, aft => 6, exp => 0);
    put (", ");
    put (eval (p, ptr.tp).y, fore => 1, aft => 6, exp => 0);
    put (")");
    set_col (to => 38);
    put (ptr.tq, fore => 1, aft => 6, exp => 0);
    set_col (to => 48);
    put ("(");
    put (eval (q, ptr.tq).x, fore => 1, aft => 6, exp => 0);
    put (", ");
    put (eval (q, ptr.tq).y, fore => 1, aft => 6, exp => 0);
    put_line (")");
    ptr := ptr.next;
  end loop;
end bezier_intersections;

model F22 "Simple spring/damper/mass system"

    constant Real pi = 3.1415926;

    parameter Real l0 = 50            "initial tether length        [m]";
    parameter Real d_tether = 4       "tether diameter                  [mm]";
    parameter Real rho_tether = 724   "density of Dyneema            [kg/m³]";
    parameter Real c_spring = 614600  "unit spring constant              [N]";
    parameter Real damping = 473      "unit damping constant            [Ns]";
    parameter Integer segments= 5     "number of tether segments         [-]";
    parameter Real alfa0 = 6.0/10.0*pi "initial tether angle            [rad]"; // -pi/10

    parameter Real len_per_segment = l0/segments;
    parameter Real mass_per_meter = rho_tether * pi * (d_tether/2000.0)^2;
    parameter Real springForce = c_spring/len_per_segment;
    parameter Real mass_per_seg = mass_per_meter * len_per_segment;

    inner Modelica.Mechanics.MultiBody.World world(animateGround = false, axisLength = 0.6, enableAnimation = false, n = {0, 0, -1}) annotation(    Placement(visible = true, transformation(origin = {0, 10}, extent = {{-80, -10}, {-60, 10}}, rotation = 0)));

    Element element1 (mass=mass_per_seg, len_segment=len_per_segment, cSpring=springForce, damp=damping, phiStart = alfa0)  annotation(    Placement(visible = true, transformation(origin = {-30, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Element element2 (mass=mass_per_seg, len_segment=len_per_segment, cSpring=springForce, damp=damping) annotation(    Placement(visible = true, transformation(origin = {10, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Element element3 (mass=mass_per_seg, len_segment=len_per_segment, cSpring=springForce, damp=damping) annotation(    Placement(visible = true, transformation(origin = {50, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Element element4 (mass=mass_per_seg, len_segment=len_per_segment, cSpring=springForce, damp=damping) annotation(    Placement(visible = true, transformation(origin = {90, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Element element5 (mass=mass_per_seg, len_segment=len_per_segment, cSpring=springForce, damp=damping) annotation(    Placement(visible = true, transformation(origin = {130, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));


equation
  connect(world.frame_b, element1.frame_a)    annotation(    Line(points = {{-60, 10}, {-40, 10}}));
  connect(element2.frame_b, element3.frame_a) annotation(    Line(points = {{20, 10}, {40, 10}}));
  connect(element3.frame_b, element4.frame_a) annotation(    Line(points = {{60, 10}, {80, 10}}));
  connect(element4.frame_b, element5.frame_a) annotation(    Line(points = {{100, 10}, {120, 10}}));
  connect(element1.frame_b, element2.frame_a) annotation(    Line(points = {{-20, 10}, {0, 10}}));
  annotation(
    experiment(StopTime = 10, StartTime = 0, Tolerance = 1e-06, Interval = 0.025),
    uses(Modelica(version = "4.0.0")),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian",
    __OpenModelica_simulationFlags(lv = "LOG_STDOUT,LOG_ASSERT,LOG_STATS", noEquidistantTimeGrid = "()", s = "dassl", variableFilter = ".*"),
  Diagram(coordinateSystem(extent = {{-100, -100}, {200, 100}})),
  Icon(coordinateSystem(extent = {{-100, -100}, {200, 100}})),
  version = "");
end F22;

model Element
  parameter Boolean animation = false "= true, if animation shall be enabled";
  parameter Real mass = 1;
  parameter Real len_segment = 10.0;
  parameter Real cSpring = 15;
  parameter Real damp = 20;
  parameter Real phiStart = 0.0;
  Modelica.Mechanics.MultiBody.Parts.Body body1(m=mass, I_11 = 0.01, I_22 = 0.01, I_33 = 0.01, cylinderDiameter = 0.05, r_CM = {0, 0, 0}, sphereDiameter = 0.2) annotation(
    Placement(visible = true, transformation(origin = {68, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Mechanics.MultiBody.Forces.Spring spring(animation = animation, c = cSpring, coilWidth = 0.01, numberOfWindings = 5, s_unstretched = len_segment) annotation(    Placement(transformation(extent = {{0, -60}, {20, -40}})));
  Modelica.Mechanics.MultiBody.Forces.Damper damper(animation = animation, d = damp, diameter_a = 0.08, length_a = 0.1) annotation(    Placement(transformation(extent = {{0, -40}, {20, -20}})));
  Modelica.Mechanics.MultiBody.Joints.Revolute revolute(n = {0, 1, 0},phi(fixed = true, start = phiStart), w(fixed = true)) annotation(    Placement(visible = true, transformation(origin = {-32, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Mechanics.MultiBody.Joints.Prismatic prismatic(boxColor = {255, 65, 65}, boxWidth = 0.04, n = {1, 0, 0}, s(fixed = true, start = len_segment)) annotation(    Placement(visible = true, transformation(origin = {-16, 0}, extent = {{20, -10}, {40, 10}}, rotation = 0)));
  Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_a annotation(    Placement(visible = true, transformation(origin = {-96, 10}, extent = {{-16, -16}, {16, 16}}, rotation = 0), iconTransformation(origin = {-98, 0}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  Modelica.Mechanics.MultiBody.Interfaces.Frame_b frame_b annotation(    Placement(visible = true, transformation(origin = {96, 4}, extent = {{-16, -16}, {16, 16}}, rotation = 0), iconTransformation(origin = {96, 4}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));

equation
  connect(prismatic.frame_a, revolute.frame_b) annotation(    Line(points = {{4, 0}, {-22, 0}}, color = {95, 95, 95}, thickness = 0.5));
  connect(damper.frame_b, prismatic.frame_b) annotation(    Line(points = {{20, -30}, {50, -30}, {50, 0}, {24, 0}}, color = {95, 95, 95}, thickness = 0.5));
  connect(spring.frame_b, prismatic.frame_b) annotation(    Line(points = {{20, -50}, {50, -50}, {50, 0}, {24, 0}}, color = {95, 95, 95}, thickness = 0.5));
  connect(body1.frame_a, prismatic.frame_b) annotation(    Line(points = {{58, 0}, {24, 0}}, color = {95, 95, 95}, thickness = 0.5));
  connect(damper.frame_a, revolute.frame_b) annotation(    Line(points = {{0, -30}, {-22, -30}, {-22, 0}}, color = {95, 95, 95}));
  connect(spring.frame_a, revolute.frame_b) annotation(    Line(points = {{0, -50}, {-22, -50}, {-22, 0}}, color = {95, 95, 95}));
  connect(frame_a, revolute.frame_a) annotation(    Line(points = {{-96, 10}, {-66, 10}, {-66, 0}, {-42, 0}}));
  connect(frame_b, body1.frame_a) annotation(    Line(points = {{96, 4}, {98, 4}, {98, 44}, {58, 44}, {58, 0}}));
  annotation(
    uses(Modelica(version = "4.0.0")),
  Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}})),
  Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}})),
  version = "");
end Element;

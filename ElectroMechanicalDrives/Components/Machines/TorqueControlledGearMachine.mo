within ElectroMechanicalDrives.Components.Machines;
model TorqueControlledGearMachine "Signal torque input machine including loss, inertia and gear"
  extends ElectroMechanicalDrives.Icons.GearMachine;
  Modelica.Mechanics.Rotational.Interfaces.Flange_b flange "Load flange"
                                                           annotation(Placement(transformation(extent = {{90, -10}, {110, 10}})));
  parameter Real ratio = 1
    "Transmission ratio of gear (wMachine/wLoad)";
  parameter Real efficiency = 1 "Efficiency of gear";
  parameter Modelica.SIunits.Inertia J = 0 "Total inertia of machine w.r.t machine speed" annotation(Evaluate = true);

  parameter Boolean useFieldWeakening = false
    "True, if field weakening is considered";
  parameter Modelica.SIunits.Torque tauLimit = Modelica.Constants.inf
    "Torque limit";
  parameter Modelica.SIunits.AngularVelocity wBase = Modelica.Constants.inf
    "Base angular frequency"  annotation(Dialog(enable=useFieldWeakening));

  Modelica.Blocks.Interfaces.RealInput tau_ref(unit = "N.m") "Reference torque as input signal"                                                          annotation(Placement(transformation(extent = {{-140, -20}, {-100, 20}}, rotation = 0)));

  Modelica.SIunits.Angle phiMachine "Absolute rotation angle of machine";
  Modelica.SIunits.AngularVelocity wMachine = speedMachineSensor.w "Speed of electric machine";
  Modelica.SIunits.AngularAcceleration aMachine "Absolute rotational acceleration of machine";
  Modelica.SIunits.Torque tauMachine = torqueMachineSensor.tau "Total electromagnetic torque of electric machine";
  Modelica.SIunits.Power powerMachine = powerMachineSensor.power "Total electromagnetic power of electric machine";

  Modelica.SIunits.Angle phiLoad "Absolute rotation angle of load flange";
  Modelica.SIunits.AngularVelocity wLoad= speedLoadSensor.w "Speed of mechanical load";
  Modelica.SIunits.AngularAcceleration aLoad "Absolute rotational acceleration of load flange";
  Modelica.SIunits.Torque tauLoad = torqueLoadSensor.tau "Torque of mechanical load";
  Modelica.SIunits.Power powerLoad = powerLoadSensor.power "Power of mechanical load";

  Modelica.SIunits.Angle phiShaft = phiMachine "Absolute rotation angle";
  Modelica.SIunits.AngularVelocity wShaft = wMachine "Angular velcocity";
  Modelica.SIunits.AngularAcceleration aShaft = aMachine  "Absolute rotational acceleration";
  Modelica.SIunits.Torque tauShaft = torqueShaftSensor.tau "Torque of machine shaft (considering inertia)";
  Modelica.SIunits.Power powerShaft = powerShaftSensor.power "Power of electric machine shaft (considering inertia)";


  Modelica.Mechanics.Rotational.Sources.Torque torque annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-70,30})));
  Modelica.Mechanics.Rotational.Components.IdealGear idealGear(final ratio = ratio) annotation(Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 0, origin = {40, -80})));
  Modelica.Mechanics.Rotational.Components.Inertia inertia(J = J) annotation(Placement(transformation(extent = {{-60, -90}, {-40, -70}})));
  Modelica.Mechanics.Rotational.Sensors.TorqueSensor torqueMachineSensor annotation(Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 270, origin = {-70, -60})));
  Modelica.Mechanics.Rotational.Sensors.PowerSensor powerMachineSensor annotation(Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 270, origin = {-70, -30})));
  Modelica.Mechanics.Rotational.Sensors.TorqueSensor torqueShaftSensor annotation(Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 0, origin = {-20, -80})));
  Modelica.Mechanics.Rotational.Sensors.PowerSensor powerLoadSensor annotation(Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {90, -50})));
  ElectroMechanicalDrives.Components.Rotational.ConstantEfficiency efficiencyGear(final efficiency=efficiency) annotation (Placement(transformation(extent={{60,-90},{80,-70}})));
  Modelica.Mechanics.Rotational.Sensors.TorqueSensor torqueLoadSensor annotation(Placement(transformation(extent={{10,10},{-10,-10}},      rotation = 270, origin = {90, -20})));
  Modelica.Mechanics.Rotational.Sensors.PowerSensor powerShaftSensor annotation(Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 0, origin = {10, -80})));
  ElectroMechanicalDrives.Components.Machines.TorqueLimiter torqueLimiter(
    final useFieldWeakening=useFieldWeakening,
    final tauLimit=tauLimit,
    final wBase=wBase) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-70,60})));
  Modelica.Mechanics.Rotational.Sensors.SpeedSensor speedMachineSensor
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Mechanics.Rotational.Sensors.SpeedSensor speedLoadSensor
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
equation
  // Machine equations
  phiMachine = idealGear.flange_a.phi;
  aMachine = der(wMachine);
  // Load equations
  phiLoad = flange.phi;
  aLoad = der(wLoad);
  connect(torqueMachineSensor.flange_b, inertia.flange_a) annotation(Line(points = {{-70, -70}, {-70, -80}, {-60, -80}}, color = {0, 0, 0}, smooth = Smooth.None));
  connect(powerMachineSensor.flange_b, torqueMachineSensor.flange_a) annotation(Line(points = {{-70, -40}, {-70, -50}}, color = {0, 0, 0}, smooth = Smooth.None));
  connect(inertia.flange_b, torqueShaftSensor.flange_a) annotation(Line(points = {{-40, -80}, {-30, -80}}, color = {0, 0, 0}, smooth = Smooth.None));
  connect(efficiencyGear.flange_b, powerLoadSensor.flange_a) annotation(Line(points={{80,-80},
          {90,-80},{90,-60}},                                                                                            color = {0, 0, 0}, smooth = Smooth.None));
  connect(efficiencyGear.flange_a, idealGear.flange_b) annotation(Line(points={{60,-80},
          {50,-80}},                                                                                    color = {0, 0, 0}, smooth = Smooth.None));
  connect(torqueShaftSensor.flange_b, powerShaftSensor.flange_a) annotation(Line(points = {{-10, -80}, {-4.44089e-16, -80}}, color = {0, 0, 0}, smooth = Smooth.None));
  connect(powerShaftSensor.flange_b, idealGear.flange_a) annotation(Line(points = {{20, -80}, {30, -80}}, color = {0, 0, 0}, smooth = Smooth.None));
  connect(torqueLoadSensor.flange_b, flange) annotation (Line(points={{90,-10},{90,-10},{90,0},{100,0}}, color={0,0,0}));
  connect(torqueLoadSensor.flange_a, powerLoadSensor.flange_b) annotation (Line(points={{90,-30},{90,-35},{90,-40}}, color={0,0,0}));
  connect(torqueLimiter.tauLimited, torque.tau) annotation (Line(points={{-70,49},{-70,42}}, color={0,0,127}));
  connect(torqueLimiter.tau, tau_ref) annotation (Line(points={{-70,72},{-70,72},
          {-70,80},{-100,80},{-100,0},{-120,0}},           color={0,0,127}));
  connect(torque.flange, powerMachineSensor.flange_a) annotation (Line(points={{-70,20},{-70,20},{-70,-20}}, color={0,0,0}));
  connect(speedMachineSensor.flange, torque.flange) annotation (Line(points={{-60,0},{-66,0},{-70,0},{-70,20}}, color={0,0,0}));
  connect(speedMachineSensor.w, torqueLimiter.w) annotation (Line(points={{-39,0},
          {-30,0},{-30,60},{-58,60}}, color={0,0,127}));
  connect(speedLoadSensor.flange, flange)
    annotation (Line(points={{80,0},{90,0},{100,0}}, color={0,0,0}));
  annotation(defaultComponentName = "machine", Diagram(coordinateSystem(preserveAspectRatio=false,   extent={{-100,
            -100},{100,100}})),                                                                                                    Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}), graphics={  Rectangle(origin = {90, 0}, lineColor = {64, 64, 64}, fillColor = {191, 191, 191},
            fillPattern =                                                                                                   FillPattern.HorizontalCylinder, extent = {{-10, -10}, {10, 10}}), Text(extent = {{-140, 60}, {-100, 20}}, lineColor = {0, 0, 0},
            fillPattern =                                                                                                   FillPattern.HorizontalCylinder, fillColor = {175, 175, 175}, textString = "tau"), Text(extent = {{-150, 120}, {150, 80}}, textString = "%name", lineColor = {0, 0, 255}), Line(points = {{-100, 0}, {-60, 0}}, color = {0, 0, 0}, smooth = Smooth.None),
                                                                                                                                                                                                        Text(extent={{-150,-110},{150,-150}},                         lineColor={0,0,0},
          textString="ratio=%ratio"),                                                                                                                                                                       Text(extent={{-150,-150},{150,-190}},                         lineColor={0,0,0},
          textString="eff=%efficiency")}),
    Documentation(info="<html>
<p>This is an idealized torque controlled electric machine model with integrated gear considering constant gear efficiency. 
The actual torque of the <em>electric machine</em> can be adjusted by means of the signal input.</p>

<p>
<img src=\"modelica://ElectroMechanicalDrives/Resources/Images/GearMachine.png\">
<br>
Fig. 1: Principle of controlled machine model with gear and gear efficiency
</p>

<p>The following variables are calculated in the model</p>
<ul>
<li>Machine</li>
    <ul>
    <li><code>aMachine</code> = angular acceleration of machine</li>
    <li><code>phiMachine</code> = mechanical angle of machine</li>
    <li><code>wMachine</code> = angular velocity of machine</li>
    <li><code>tauMachine</code> = (electrical) torque of machine</li>
    <li><code>powerMachine</code> = power of machine</li>
    </ul>
<li>Shaft</li>
    <ul>
    <li><code>aShaft</code> = angular acceleration of shaft</li>
    <li><code>phiShaft</code> = mechanical angle of shaft</li>
    <li><code>wShaft</code> = angular velocity of shaft</li>
    <li><code>tauShaft</code> = torque of shaft</li>
    <li><code>powerShaft</code> = power of shaft</li>
    </ul>
<li>Load</li>
    <ul>
    <li><code>aLoad</code> = angular acceleration of load</li>
    <li><code>phiLoad</code> = mechanical angle of load</li>
    <li><code>wLoad</code> = angular velocity of load</li>
    <li><code>tauLoad</code> = torque of load</li>
    <li><code>powerLoad</code> = power of load</li>
    </ul>
</ul>

<p>This machine model considers the following effects:</p>
<ul>
<li>Internal gear ratio to produce a higher output torque</li>
<li>Total mechanical efficiency due to friction and gear</li>
<li>Inertia with respect to electric machine side</li>
<li>Optional field weaking is considered by<li>
    <ul>
    <li>the maximum torque of the machine, <code>tauLimit</code> for <code>w &le; wBase</code></li>
    <li>the base speed limit <code>wBase</code><li>
    <li>torque reduction proportial to <code>wBase/w</code> for <code>w &gt; wBase</code></li> 
    </ul>
</ul>

</html>"));
end TorqueControlledGearMachine;

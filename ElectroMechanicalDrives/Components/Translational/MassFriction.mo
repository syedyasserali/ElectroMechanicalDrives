within ElectroMechanicalDrives.Components.Translational;
model MassFriction "Constant force with linear range around zero speed"
  extends ElectroMechanicalDrives.Interfaces.PartialMassFriction;
equation
  f_friction = smooth(1, if v > v_linear then f_frictionSliding else if v < (-v_linear) then -f_frictionSliding else f_frictionSliding * v / v_linear);
  annotation (Documentation(info="<html>
<p>
In this model considers the inertial mass <code>m</code> including the following effects:
</p>
<ul>
<li>Inclination or declination, being constant (<code>useConstantAngle = true</code>) or time dependent (<code>useConstantAngle = false</code>)</li>
<li><a href=\"modelica://ElectroMechanicalDrives.Components.Translational.RollingFriction\">Rolling friction</a> 
    force determined by friction coefficient <code>mu</code></li>
</ul>
</html>"));
end MassFriction;

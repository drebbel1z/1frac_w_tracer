# Longitudinal dispersivity
disp = 0.7

[Variables]
  [C]
    initial_condition = 1e-7
    scaling = 1e-6 #fixme maybe not needed?
  []
[]
[Kernels]
  [diff_pp]
    type = PorousFlowDispersiveFlux
    fluid_component = 1
    variable = porepressure
    disp_trans = 0
    disp_long = ${disp}
  []
  [diff_C]
    type = PorousFlowDispersiveFlux
    fluid_component = 0
    variable = C
    disp_trans = 0
    disp_long = ${disp}
  []
[]
[AuxVariables]
  [Darcy_vel_x]
    order = CONSTANT
    family = MONOMIAL
  []
  [Darcy_vel_y]
    order = CONSTANT
    family = MONOMIAL
  []
  [Darcy_vel_z]
    order = CONSTANT
    family = MONOMIAL
  []
[]
[AuxKernels]
  [Darcy_vel_x]
    type = PorousFlowDarcyVelocityComponent
    variable = Darcy_vel_x
    component = x
    fluid_phase = 0
  []
  [Darcy_vel_y]
    type = PorousFlowDarcyVelocityComponent
    variable = Darcy_vel_y
    component = y
    fluid_phase = 0
  []
  [Darcy_vel_z]
    type = PorousFlowDarcyVelocityComponent
    variable = Darcy_vel_z
    component = z
    fluid_phase = 0
  []
[]

[Materials]
  [diff]
    type = PorousFlowDiffusivityConst
    diffusion_coeff = '0 0'
    tortuosity = 0.1
  []
[]

[DiracKernels]
  [withdraw_tracer]
    type = PorousFlowPeacemanBorehole
    variable = C
    bottom_p_or_t = insitu_pp_borehole
    SumQuantityUO = borehole_tracer_outflow_mass
    point_file = peaceman_production_points.txt
    function_of = pressure
    fluid_phase = 0
    unit_weight = '0 0 -${water_weight}'
    use_mobility = true
    mass_fraction_component = 0
    character = 1
    point_not_found_behavior = WARNING
    line_direction = '0 0 1'
    line_length = 1.0
  []
[]
[UserObjects]
  [borehole_tracer_outflow_mass]
    type = PorousFlowSumQuantity
  []
[]
[Postprocessors]
  [tracer_report]
    type = PorousFlowPlotQuantity
    uo = borehole_tracer_outflow_mass
  []
  [darcy_x_in_10]
    type = PointValue
    variable = Darcy_vel_x
    point = '-92.03668092 209.7649026 441.140982'
  []
  [darcy_y_in_10]
    type = PointValue
    variable = Darcy_vel_y
    point = '-92.03668092 209.7649026 441.140982'
  []
  [darcy_z_in_10]
    type = PointValue
    variable = Darcy_vel_z
    point = '-92.03668092 209.7649026 441.140982'
  []
  [darcy_x_out_z_539.4]
    type = PointValue
    variable = Darcy_vel_x
    point = '-88.2258436 210.175623 539.3692902'
  []
  [darcy_y_out_z_539.4]
    type = PointValue
    variable = Darcy_vel_y
    point = '-88.2258436 210.175623 539.3692902'
  []
  [darcy_z_out_z_539.4]
    type = PointValue
    variable = Darcy_vel_z
    point = '-88.2258436 210.175623 539.3692902'
  []
[]

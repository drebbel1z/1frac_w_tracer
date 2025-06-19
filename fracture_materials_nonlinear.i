# created by write_frac_materials_input.py
# see Materials Property section in porous flow notes:
# https://mooseframework.inl.gov/modules/porous_flow/multiapp_fracture_flow_PorousFlow_3D.html
# DFN from fname
all_frac_ids = "fracture1 "

frac_roughness_1 = ${frac_roughness}
frac_aperture_1 = ${frac_aperature}
aper_Hi = ${frac_aperture_1}
aper_Lo = 1e-5
# decay_factor = 100
# frac_radius = 60

one_over_bulk = 1.4e-11 #bulk modulus = 70GPa

[AuxVariables]
  [aperture_fracture1]
    order = CONSTANT
    family = MONOMIAL
  []
[]

[AuxKernels]
  [aperture_fracture1]
    # type = ParsedAux
    # variable = aperture_fracture1
    # #This is a circle.
    # #it would be better to use distance from a line segement
    # #coordinates for zone 10 a=injection and b=production
    # #aHi is the max initial aperature
    # #aLo is the low initial aperature
    # #decayFactor determines how fast it decays from hi to low,
    # constant_names = 'ax ay az
    #                   bx by bz
    #                   aHi aLo decayFactor radius'
    # constant_expressions = '4.1345165890 220.1299407155 396.4301458718
    #                         4.1345165890 220.1299407155 496.4301458718
    #                         ${aper_Hi} ${aper_Lo} ${decay_factor} ${frac_radius}'
    # expression = 'c_x:=(bx-ax)/2+ax; c_y:=(by-ay)/2+ay; c_z:=(bz-az)/2+az;
    #               r_outside:=sqrt((x-c_x)^2+(y-c_y)^2+(z-c_z)^2)-50;
    #               a:=if(r_outside<0,aHi,aHi-(aHi-aLo)/decayFactor*r_outside);
    #               if(a>aLo,a,aLo)' # linear decay, aperture can go negative so check

    # # 'if(r_outside<0,aHi,aLo+aHi*exp(-decayFactor*r_outside))' # exponential decay
    # use_xyzt = true

    type=ApertureFractureLine
    variable = aperture_fracture1
    start_point ='4.1345165890 220.1299407155 396.4301458718'
    end_point ='4.1345165890 220.1299407155 496.4301458718'
    a_max = '${aper_Hi}'
    a_min = '${aper_Lo}'
    midpoint_of_sigmoid = 50
    slope_at_midpoint =0.01 
    block = 'fracture1'
    execute_on = 'INITIAL'
  []
[]

[Materials]
  [porosity_fracture1]
    type = PorousFlowPorosityLinear
    porosity_ref = aperture_fracture1
    P_ref = insitu_pp
    P_coeff = ${one_over_bulk}
    porosity_min = '${fparse frac_aperture_1/10}'
    block = fracture1
  []
  [permeability_fracture49]
    type = PorousFlowPermeabilityKozenyCarman
    poroperm_function = kozeny_carman_A
    A = '${fparse frac_roughness_1/12}'
    m = 0
    n = 3
    block = fracture1
  []
[]

[Materials]
  # [porosity_fracture1]
  #   type = PorousFlowPorosityLinear
  #   porosity_ref = ${frac_aperture_1}
  #   P_ref = insitu_pp
  #   P_coeff = ${one_over_bulk}
  #   porosity_min = '${fparse frac_aperture_1/10}'
  #   block = fracture1
  # []
  # [permeability_fracture1]
  #   type = PorousFlowPermeabilityKozenyCarman
  #   k0 = '${fparse frac_roughness_1/12*frac_aperture_1^3}'
  #   poroperm_function = kozeny_carman_phi0
  #   m = 0
  #   n = 3
  #   phi0 = ${frac_aperture_1}
  #   block = fracture1
  # []

  [rock_internal_energy_fracture]
    type = PorousFlowMatrixInternalEnergy
    density = 2500
    specific_heat_capacity = 100.0
    block = ${all_frac_ids}
  []

  [thermal_conductivity_fracture]
    type = PorousFlowThermalConductivityIdeal
    dry_thermal_conductivity = '3 0 0 0 3 0 0 0 3'
    block = ${all_frac_ids}
  []
[]

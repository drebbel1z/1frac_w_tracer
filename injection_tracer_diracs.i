# created by write_diracs_input.py
[DiracKernels]
  [source_1_tracer]
    type = PorousFlowSquarePulsePointSource
    variable = C
    mass_flux = '${fparse inj_ratio_stage_1*tracer_flux_src}'
    point = '4.1345165890 220.1299407155 396.4301458718'
    start_time = ${tracer_start_time}
    end_time = ${tracer_end_time}
    point_not_found_behavior = WARNING
  []
[]

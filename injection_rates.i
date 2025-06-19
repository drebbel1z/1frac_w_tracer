####### INJECTION RATES AND POSTPROCESSORS
# created by write_diracs_input.py

inj_ratio_stage_1 = 0.25

[Postprocessors]
  [mass_flux_src_stage_1]
    type = FunctionValuePostprocessor
    function = mass_flux_src
    scale_factor = ${inj_ratio_stage_1}
    execute_on = 'initial timestep_end'
  []
[]
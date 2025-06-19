[StochasticTools]
[]

[Distributions]
  [fracture_aperture]
    type = Uniform
    lower_bound = 1e-6
    upper_bound = 1e-3
  []
  [matrix_poro]
    type = Uniform
    lower_bound = 1e-6
    upper_bound = 1e-3
  []

  [midpoint_of_sigmoid]
    type = Uniform
    lower_bound = 100
    upper_bound = 1
  []

  [slope_at_midpoint]
    type = Uniform
    lower_bound = 1e-3
    upper_bound = 1
  []
[]

[ParallelAcquisition]
  [expectedimprovement]
    type = ThompsonSampling
    # tuning = 0.01
    require_full_covariance = true
  []
[]

[Samplers]
  [sample]
    type = GenericActiveLearningSampler
    distributions = 'fracture_aperture matrix_poro midpoint_of_sigmoid slope_at_midpoint'
    sorted_indices = 'conditional/sorted_indices'
    num_parallel_proposals = 12
    num_tries = 5000
    seed = 100
    execute_on = PRE_MULTIAPP_SETUP
    initial_values = "2e-4 2e-4 2e-4 2e-4"
  []
[]

[MultiApps]
  [sub]
    type = SamplerFullSolveMultiApp
    input_files = 2dFrac_10zone.i
    sampler = sample
  []
[]

[Transfers]
  [reporter_transfer]
    type = SamplerReporterTransfer
    from_reporter = 'log_inverse_error/value'
    stochastic_reporter = 'constant'
    from_multi_app = sub
    sampler = sample
  []
[]

[Controls]
  [cmdline]
    type = MultiAppSamplerControl
    multi_app = sub
    sampler = sample
    param_names = 'frac_aperature matrix_poro AuxKernels/aperture_fracture1/midpoint_of_sigmoid AuxKernels/aperture_fracture1/slope_at_midpoint'
  []
[]

[Reporters]
  [constant]
    type = StochasticReporter
  []
  [conditional]
    type = GenericActiveLearner
    output_value = constant/reporter_transfer:log_inverse_error:value
    sampler = sample
    al_gp = GP_al_trainer
    gp_evaluator = GP_eval
    acquisition = 'expectedimprovement'
    penalize_acquisition = false
  []
[]

[Trainers]
  [GP_al_trainer]
   type = ActiveLearningGaussianProcess
    covariance_function = 'covar'
    standardize_params = 'true'
    standardize_data = 'true'
    tune_parameters = 'covar:signal_variance covar:length_factor'
    num_iters = 700
    learning_rate = 0.001
    # show_every_nth_iteration = 2
    batch_size = 350
  []
[]

[Surrogates]
  [GP_eval]
    type = GaussianProcessSurrogate
    trainer = GP_al_trainer
  []
[]

[Covariance]
  # [covar]
  #   type = SquaredExponentialCovariance
  #   signal_variance = 4.0
  #   noise_variance = 1e-6
  #   length_factor = '1.0 1.0'
  # []

  [covar]
    type = MaternHalfIntCovariance
    signal_variance = 4.0
    noise_variance = 1e-6
    length_factor = '10.0 10.0 10.0 10.0'
    p=1
  []
[]

[Executioner]
  type = Transient
  num_steps = 30
[]

[Outputs]
  file_base = 'al1'
  [out1_parallelAL]
    type = JSON
    execute_system_information_on = NONE
  []
[]

# A first-order flexible ELA model based on geomorphic constraints

This page documents a flexible model to estimate steady-state equilibrium line altitudes (ELAs) of clean-ice, temperate alpine glaciers based on geomorphic inputs.
When using this model, please cite the [original publication](https://doi.org/10.1016/j.mex.2020.101173).
Also consider notifying me (durban.keeler@gmail.com) to help me gauge the use and interest in the project.

## Background information

Alpine glaciers, with their valuable combination of highly sensitive response to climate and near-global extent, are powerful tools for investigating previous and present climate changes.
They also represent critical water resources for areas around the globe, with the potential for far-reaching effects in a warming world.
Advancements to understand and model glacial changes and the variables influencing them are therefore relevant to many fields.
This page contains code for a physical steady-state model for alpine glaciers relating directly to glacier mass balance (via the equilibrium line altitude) while retaining the simplicity of other morphology methods and simultaneously including error estimates.
The model consists of custom MATLAB functions to produce ELA estimates in a user-friendly and generally-applicable method from only a limited number of glacier bed topography and glacier width measurements.

## Model components

The primary functions of the ELA model are located in the `src/` directory.
The ELA model function `ELA_calc.m` requires two dataset inputs (discrete estimates of bed topography and discrete estimates of glacier width, both measured downglacier along the centerline of the glacier valley) and the number of Monte Carlo simulations to perform.
Approximately ten quasi-equally spaced points along the length of the glacier are often sufficient, though the optimum number depends on the length and complexity of the bed topography and glacier geometry.
To avoid issues of model extrapolation (and to automatically include the overall glacier length), both the toe and the head of the glacier should be included in these measurements.
The ELA model input data should be provided as a MATLAB structure with four fields, as summarized in Table 1.
Tributary glaciers, if present, should be provided as variable input arguments (formatted as MATLAB structures according to Table 1) after the number of simulations to perform.
The `format_inputs.m` function takes .csv files of glacier bed topography and glacier width measurements and creates a properly-formatted MATLAB structure to serve as input to the ELA model.

**Table 1: Required format for ELA model inputs**

| Field name  | Dimensions | Field description                                                                         |
|-------------|------------|-------------------------------------------------------------------------------------------|
|  `X_dist`   | [N X 1] |  Vector of glacier length from 0:N, where N is the total length of the glacier in meters. |
|  `Bed_pts`  | [n X 2] |  A matrix with positions along the glacier centerline (in meters) in the first column and corresponding bed elevation measurements (meters a.s.l.) in the second.  |
|  `Ice_surf` | [n X 2] | A matrix with positions along the glacier centerline (in meters) in the first column (this should match the first column in 'Bed_pts') and corresponding ice surface  elevation measurements (meters a.s.l.) in the second.  |
| `Width_pts` | [m X 2] | A matrix with positions along the glacier centerline (in meters) in the first column and corresponding glacier width measurements (meters) in the second (widths should orthogonally intersect the centerline). |

In addition to the inputs, there are model parameter assumptions built into the model prescribing the assumed errors for Monte Carlo sampling.
Updating these assumptions to better reflect specific input data is a simple matter of editing the assigned values.
Table 2 shows a summary of these parameters and their default values.

**Table 2: ELA model error assumptions**

| Variable name | Default value | Variable description                                            |
|---------------|---------------|-----------------------------------------------------------------|
|    `zSTD`     |     25 meters      | Standard deviation in measured glacier bed elevation. |
|    `wSTD`     |     60 meters      | Standard deviation in measured glacier width values.  |
|  `tau_STD`    | 5E10<sup>4</sup> Pa | Standard deviation in estimated basal shear stress (used in ice thickness calculations). |
|    `rho`      | 917 kg/m<sup>3</sup> | Density of ice (used in ice thickness calculations). |
|     `g`       |  9.8 m/s<sup>2</sup> | Acceleration due to gravity (used in ice thickness calculations). |

## Misc notes

An example of how to use the ELA model is included in the `scripts` directory entitled `example.m`.
This uses data from a handful of Swiss glaciers (recorded in the `Data` directory - the [original publication](https://doi.org/10.1016/j.mex.2020.101173) for full details) to demonstrate the model's use and to show some of the outputs of the model.
The example script also utilizes a function called `shadedErrorBar` (included in the `src` directory).
The function was developed by Rob Campbell and can be found on [his Github page](https://github.com/raacampbell/shadedErrorBar).

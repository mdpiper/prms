module PRMS_PRECIPITATION
  use variableKind
  use ModelBase_class, only: ModelBase
  use prms_constants, only: dp
  use Control_class, only: Control
  use Parameters_class, only: Parameters
  use PRMS_SET_TIME, only: Time_t
  use PRMS_BASIN, only: Basin
  use PRMS_TEMPERATURE, only: Temperature
  implicit none

  private
  public :: Precipitation

  character(len=*), parameter :: MODDESC = 'Precipitation distribution'
  character(len=*), parameter :: MODNAME = 'precipitation'
  character(len=*), parameter :: MODVERSION = '2018-08-30 17:09:00Z'

  type, extends(ModelBase) :: Precipitation
    ! Basin variables
    real(r64) :: basin_obs_ppt
    real(r64) :: basin_ppt
    real(r64) :: basin_rain
    real(r64) :: basin_snow

    real(r32), allocatable :: hru_ppt(:)
    real(r32), allocatable :: hru_rain(:)
    real(r32), allocatable :: hru_snow(:)
    real(r32), allocatable :: prmx(:)

    real(r32), allocatable :: tmax_allrain(:, :)
    real(r32), allocatable :: tmax_allrain_c(:, :)
    real(r32), allocatable :: tmax_allrain_f(:, :)
    real(r32), allocatable :: tmax_allsnow_c(:, :)
    real(r32), allocatable :: tmax_allsnow_f(:, :)

    integer(i32), allocatable :: newsnow(:)
    integer(i32), allocatable :: pptmix(:)

    contains
      procedure, public :: run => run_Precipitation
      procedure, public :: set_precipitation_form
  end type

  interface Precipitation
    !! Precipitation constructor
    module function constructor_Precipitation(ctl_data, param_data) result(this)
      type(Precipitation) :: this
        !! Precipitation class
      type(Control), intent(in) :: ctl_data
        !! Control file parameters
      type(Parameters), intent(in) :: param_data
    end function
  end interface

  interface
    module subroutine run_Precipitation(this, ctl_data, param_data, model_basin, model_temp, model_time)
      class(Precipitation), intent(inout) :: this
      type(Control), intent(in) :: ctl_data
      type(Parameters), intent(in) :: param_data
      type(Basin), intent(in) :: model_basin
      class(Temperature), intent(in) :: model_temp
      type(Time_t), intent(in), optional :: model_time
    end subroutine
  end interface

  interface
    module subroutine set_precipitation_form(this, ctl_data, param_data, model_basin, model_temp, &
                                             month, rain_adj, snow_adj, rainmix_adj)
      class(Precipitation), intent(inout) :: this
      type(Control), intent(in) :: ctl_data
      type(Parameters), intent(in) :: param_data
      type(Basin), intent(in) :: model_basin
      class(Temperature), intent(in) :: model_temp
      integer(i32), intent(in) :: month
      real(r32), optional, intent(in) :: rain_adj(:)
        !! Array of rain adjustments
      real(r32), optional, intent(in) :: snow_adj(:)
        !! Array of snow adjustments
      real(r32), optional, intent(in) :: rainmix_adj(:)
        !! Array of rain mixture adjustments
    end subroutine
  end interface
end module

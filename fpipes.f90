!!! 2012/11/18 JM
!!! based on
!!!		comp.lang.fortran, 12/02/2009 08:38 AM, David Duffy 'C interop to popen'
!!! TODO: include interface to fputs - in order to also write to pipe!
!!!
module fpipes
  ! 
  ! global
  !
  use, intrinsic :: ISO_C_BINDING
  !
  implicit none
  !
  private
  !
  type, public :: streampointer
    type (c_ptr) :: handle = c_null_ptr
  end type streampointer
  !
  !
  ! interfaces to C library functions
  public :: popen, pclose
  public :: fgets, fputs
  !
  ! popen
  interface
    function popen(path, mode) bind(C, name='popen')
      use, intrinsic :: ISO_C_BINDING
	  implicit none
      character(kind=c_char), dimension(*) :: path, mode
      type (c_ptr) :: popen
    end function popen
  end interface
  !
  ! pclose  
  interface
    function pclose(handle) bind(C, name='pclose')
      use, intrinsic :: ISO_C_BINDING
	  implicit none	  
      integer(c_int) :: pclose
      type (c_ptr), value :: handle
    end function pclose
  end interface
  !
  ! fgets
  interface
    function fgets(buffer, size, handle) bind(C, name='fgets')
      use, intrinsic :: ISO_C_BINDING
	  implicit none	  
      type (c_ptr) :: fgets
      character(kind=c_char), dimension(*) :: buffer
      integer(kind=c_int), value :: size
      type (c_ptr), value :: handle
    end function fgets
  end interface
  !
  ! fputs
  interface
    function fputs(buffer, handle) bind(C, name='fputs')
      use, intrinsic :: ISO_C_BINDING
	  implicit none	  
      integer(kind=c_int) :: fputs
      character(kind=c_char), dimension(*) :: buffer
      type (c_ptr), value :: handle
    end function fputs
  end interface
  !
end module fpipes
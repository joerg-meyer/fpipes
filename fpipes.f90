!!! 2012/11/16 JM
!!! based on
!!!		comp.lang.fortran, 12/02/2009 08:38 AM, David Duffy 'C interop to popen'
!!! TODO: include interface to fputs - in order to also write to pipe!
!!!
module fpipes
  use, intrinsic :: ISO_C_BINDING
  type, public :: streampointer
    type (c_ptr) :: handle = c_null_ptr
  end type streampointer
! popen  
  interface
    function popen(path, mode) bind(C, name='popen')
      use, intrinsic :: ISO_C_BINDING
      character(kind=c_char), dimension(*) :: path, mode
      type (c_ptr) :: popen
    end function
  end interface
! fgets  
  interface
    function fgets(buf, siz, handle) bind(C, name='fgets')
      use, intrinsic :: ISO_C_BINDING
      type (c_ptr) :: fgets
      character(kind=c_char), dimension(*) :: buf
      integer(kind=c_int), value :: siz
      type (c_ptr), value :: handle
    end function
  end interface
! pclose  
  interface
    function pclose(handle) bind(C, name='pclose')
    use, intrinsic :: ISO_C_BINDING
    integer(c_int) :: pclose
    type (c_ptr), value :: handle
    end function
  end interface
end module fpipes
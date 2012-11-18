!!! 2012/11/16 JM
!!! based on
!!!		comp.lang.fortran, 12/02/2009 08:38 AM, David Duffy 'C interop to popen'
!!! TODO: include interface to fputs - in order to also write to pipe!
!
! Fortran interface to popen
!
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
!
! Main program 
!
program test
  use fpipes 
  integer, parameter :: BUFLEN=50000
  character(len=BUFLEN) :: lin
  character (len=3) :: mode
  integer (kind=c_int) :: clen
  integer :: eos, i
  type(streampointer) :: fp

  call get_command_argument(1,lin)
  if (lin == ' ' .or. lin == '-h' .or. lin == '--help') then
    write(*,'(a)') 'Usage: run-process <command>'
    stop
  end if 
  clen=BUFLEN-1
  mode='r'
  fp%handle = popen(trim(lin) // C_NULL_CHAR, trim(mode) // C_NULL_CHAR)
  if (.not.c_associated(fp%handle)) then
    write(*,*) 'ERROR: Could not open pipe!'
    stop
  else
    write(*,*) 'Opened pipe successfully'
  end if
  do while (c_associated(fgets(lin, clen, fp%handle)))
    eos=2
    do i=1, BUFLEN
      if (lin(i:i) == C_NULL_CHAR) then
        eos=i-2
        exit
      end if
    end do
    write(*,*) eos, ': "', trim(lin(1:eos)), '"'
  end do
  ios = pclose(fp%handle)
end program test
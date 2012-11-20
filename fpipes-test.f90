program fpipes_test
  !
  use, intrinsic :: ISO_C_BINDING, only: C_NULL_CHAR, C_NEW_LINE, c_associated
  use fpipes, only: streampointer, popen, pclose, fgets, fputs
  !
  integer, parameter :: MAXPATHLEN=256
  integer, parameter :: MAXBUFLEN=50000
  character*(*), parameter :: MODE='r' ! 'w'
  !
  ! TODO: 
  !  - find solution for bidirectional pipes:
  !    MODE='r+' allows for bi-directional communication on MacOS
  !  - N.B. EOF character is ASCII code 4
  !		http://en.wikipedia.org/wiki/ASCII
  !
  type(streampointer) :: fp
  character(len=MAXPATHLEN) :: arg, prog
  character(len=MAXBUFLEN) :: line
  integer :: eos, i
  !
  ! get command line argument and display help if necessary
  call get_command_argument(1,arg)
  if (arg == ' ' .or. arg == '-h' .or. arg == '--help') then
    write(*,'(a)') 'Usage: run-process <command>'
    stop
  end if
  prog = trim(arg)
  !
  ! open pipe
  fp%handle = popen(trim(prog) // C_NULL_CHAR, MODE // C_NULL_CHAR)
  if (.not.c_associated(fp%handle)) then
    write(*,*) 'ERROR: Could not open pipe!'
    stop
  else
    write(*,*) 'Opened pipe successfully'
  end if
  !
  ! write to pipe (requires MODE='w' at the moment to have an effect!)
  line = "This is the 1st line of GULP input." 
  i = fputs(line // C_NEW_LINE ,fp%handle)
  line = CHAR(4)
  i = fputs(line // C_NEW_LINE ,fp%handle)
  !
  ! read from pipe (requires MODE='r' at the moment to have an effect!)
  do while (c_associated(fgets(line, MAXBUFLEN-1, fp%handle)))
    ! TODO: recast this into a simpler way?!
    eos=2
    do i=1, MAXBUFLEN
      if (line(i:i) == C_NULL_CHAR) then
        eos=i-2
        exit
      end if
    end do
    write(*,*) eos, ': ', trim(line(1:eos))
  end do
  !
  ! close pipe
  ios = pclose(fp%handle)
  !
end program fpipes_test
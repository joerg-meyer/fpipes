program fpipes_test
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
end program fpipes_test
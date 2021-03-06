module setup

! ----------------------------------------------
! Setup module for romsinst2seq
!
! Bj�rn �dlandsvik, <bjorn@imr.no>
! Institute of Marine Research
! 03 March 2005
!
! Modified to be able to output specified time period
! by Nils Melsom Kristensen, met.no
! 10 Oct 2011
! ---------------------------------------------

  implicit none

  character(len=80) :: romsfile  ! Name of the ROMS file
  character(len=80) :: seqfile   ! Name of the sequential file

  integer :: kmax  ! Number of vertical z-levels in the ouput
  real, dimension(:), allocatable :: zlev  ! The vertical z-level values

  integer :: seaice  ! Switch between including sea ice variables on output file or not

  integer(kind=2), dimension(20) :: identi ! The identi to be used

  integer :: i1, i2, j1, j2
 
  integer :: t0, t1
 
  contains

  subroutine readsup(supfile)

    character(len=*), intent(in) :: supfile
    
    integer, parameter :: usup = 17   ! File unit for the setup file
!!!    character(len=80) :: line         ! A line from the setup file
    character(len=500) :: line         ! A line from the setup file

    ! --------------------------
    ! Open the setup file
    ! --------------------------
    open(unit=usup, file=trim(supfile), status='old', action='read')
    print *, "Opened supfile = ", trim(supfile)

    ! ----------------------
    ! Get file names
    ! ----------------------
    call readln(romsfile)
    print *, "romsfile = ", romsfile
    call readln(seqfile)
    print *, "seqfile  = ", seqfile

    ! --------------------
    ! Get vertical levels
    ! --------------------
    call readln(line)
    read(line, *) kmax
    allocate(zlev(kmax))
    call readln(line)
    read(line, *) zlev
  
    ! --------------------
    ! Include sea ice variables or not
    ! --------------------
    call readln(line)
    read(line, *) seaice

    ! -------------------
    ! Get the identi
    ! -------------------
    call readln(line)
    read(line, *) identi(1:10)
    call readln(line)
    read(line, *) identi(11:20)

    ! --------------------
    ! Get subarea borders
    ! --------------------
    call readln(line)
    read(line, *) i1, i2, j1, j2


    ! --------------------
    ! Get time period
    ! --------------------
    call readln(line)
    read(line, *) t0, t1

    ! ------------------
    ! Clean up
    ! ------------------
    close(usup) 

    
    contains

    ! -----------------------------
    subroutine readln(line)
    ! --------------------------------------
    !  Reads a line from a file, skipping
    !  comments and blank lines.
    !
    !  Comments starts with a character from
    !  COMCHAR and continues to the end of line.
    !
    !  Bj�rn �dlandsvik,
    !  IMR, October 1997
    ! --------------------------------------
      ! -----------------
      ! Arguments 
      ! -----------------
      character(len=*), intent(out) :: line ! Line in text file

      ! --------------------------------
      ! Local constants and variables
      ! -------------------------------
      character(len=*), parameter :: COMCHAR = "*!#"
                         ! Comment starting characters
      integer :: ipos    ! Start position for comment

      ! ------------------------------
      ! Line scanning loop
      ! ------------------------------
      do
        
        ! Read a line
        read(unit=usup, fmt="(A)") line
        ! Remove any comments
        ipos = scan(line, COMCHAR)
        if (ipos /= 0) then  
          line = line(:ipos-1)
        end if
        ! Exit loop if decommented line is not blank
        if (len_trim(line) /= 0) then  
          exit
        end if
      end do
    end subroutine readln

  end subroutine readsup  

end module setup

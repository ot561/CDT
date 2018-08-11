!>@brief program to compute matrix of a JSA
program num_hom
use olis_f90stdlib
use makeopticalelements 
implicit none

!>@param dp 
integer, parameter :: dp=selected_real_kind(15,300)

!>@param i counter
!>@param j counter
!>@param k counter
integer :: i,j,k

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! params for plotting f(w1,w2)
integer :: w1_steps, w2_steps

!>@param w1 signal freq
!>@param w2 idler freq
!>@param sigma is gaussian width
real(kind=dp) :: w1, w2, sigma

! loop params
real(kind=dp) :: w1_start, w1_end, w2_start, w2_end
real(kind=dp) :: w1_incr, w2_incr
!>@param f_mat matrix for values of function, f
complex(kind=dp), dimension(:,:), allocatable :: f_mat, mat_bs
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

!>@param nspace number of spatial modes
!>@param nspec number of spectral modes per spatial mode
!>@param n=nspace*nspec = total number of all modes
integer :: nspace, nspec, n


!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1
! for JSA calcs
complex(kind=dp), dimension(:,:), allocatable :: h, m_sq, m_sq1, m_sq2
integer :: sizeofexp, f_size

nspace=4
nspec=1
n=nspace*nspec

allocate(mat_bs(2*n,2*n))
call alloc_temparrays(nspace,nspec)

open(unit=15,file='fplot.dat', status='replace')

w1_start=-1.0_dp
w2_start=-1.0_dp

w1_end=-w1_start
w2_end=-w2_start

!0.05 
w1_incr=1.10_dp
w2_incr=1.10_dp

w1_steps=ceiling((w1_end-w1_start)/w1_incr)
w2_steps=ceiling((w2_end-w2_start)/w2_incr)

sigma=1.0_dp

allocate(f_mat(w1_steps,w2_steps))

w2=w2_start
do j=1,w2_steps
    w1=w1_start
    do i= 1,w1_steps 
        write(*,*) w1, w2, real(f(w1,w2,sigma),kind=dp)
        f_mat(i,j)=real(f(w1,w2,sigma),kind=dp)
        w1=w1+w1_incr
    end do
    w2=w2+w2_incr
end do

! modes 2 & 3 
!call make_bs(nspace,nspec,mat_bs,2,3,pi/4.0_dp)

!call printvectors(mat_bs, 'beamsplitter')
!call printvectors( matmul(mat_bs,conjg(transpose(mat_bs))), 'print bs pi/4')
!do i=1, size(f_mat,1)
!    write(15,*) j,i, (real(f_mat(i,j)), j=1, size(f_mat,1))
!end do

f_size=size(f_mat,1)
sizeofexp=4*f_size
print*, sizeofexp
allocate(m_sq(sizeofexp,sizeofexp))

!!!!!!!!!
!>@note to make off diagonal for fmatrix
!>m_sq=0.0_dp
!>! top right
!>m_sq(1:1*f_size, 3*f_size+1:4*f_size)=1
!>! mid right
!>m_sq(1*f_size+1:2*f_size, 2*f_size+1:3*f_size)=2 
!>! mid left
!>m_sq(2*f_size+1:3*f_size, 1*f_size+1:2*f_size)=3
!>! bot left
!>m_sq(3*f_size+1:4*f_size, 1:1*f_size)=4
!call printvectors(m_sq)

m_sq=0.0_dp
! top right
m_sq(1:1*f_size, 3*f_size+1:4*f_size)=f_mat(:,:)
! mid right
m_sq(1*f_size+1:2*f_size, 2*f_size+1:3*f_size)=transpose(f_mat(:,:)) 
! mid left
m_sq(2*f_size+1:3*f_size, 1*f_size+1:2*f_size)=-conjg(f_mat(:,:))
! bot left
m_sq(3*f_size+1:4*f_size, 1:1*f_size)=-conjg(transpose(f_mat(:,:)))
call printvectors(m_sq)

m_sq=expmatrix(imaginary*m_sq)
call printvectors(m_sq, 'after exp')
!h= 0.0       F_JSA
!   F_JSA*T   0.0
!
!f_jsa = f_mat

! M_sq = exp(i ( 0 H )
!              (-H* 0)

! M_sq = exp(i  (0              0           0       F_JSA) 
!               (0              0         F_JSA**T      0)
!               (0         -conjg(F_JSA)    0           0)
!               (-F_JSA**H      0           0           0)
close(15)
contains 

!>@brief JSA function taking two freq
!>@param w1 input signal freq
!>@param w2 input idler freq
!>@param sig input variance
    function f(w1,w2, sig)
    complex(kind=dp) :: f
    real(kind=dp), intent(in) :: w1,w2, sig
    
    f=(1.0_dp/(sig*sqrt(2.0_dp*pi)))**2 * exp(-0.5_dp*(w1/sig)**2)*exp(-0.5_dp*(w2/sig)**2)

    end function f
end program num_hom

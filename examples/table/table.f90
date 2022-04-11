! table.f90
! Example that shows how to access a Lua table.
program main
    use, intrinsic :: iso_c_binding, only: c_ptr
    use, intrinsic :: iso_fortran_env, only: r8 => real64
    use :: lua
    implicit none
    integer       :: rc
    real(kind=r8) :: pi
    type(c_ptr)   :: l

    l = lual_newstate()              ! Create Lua state.
    call lual_openlibs(l)            ! Open Lua standard library.
    rc = lual_dofile(l, 'table.lua') ! Open Lua file.
    rc = lua_pcall(l, 0, 0, 0)       ! Run the script once.
    rc = lua_getglobal(l, 'a')       ! Get the table.

    if (lua_istable(l, -1) == 1) then
        ! Get table field.
        rc = lua_getfield(l, -1, 'pi')

        if (lua_isnumber(l, -1) == 1) then
            ! Convert to real.
            pi  = lua_tonumber(l, -1)
            print '("pi: ", f13.11)', pi
        end if

        call lua_pop(l, 1)

        ! Get next table field.
        rc = lua_getfield(l, -1, 'foo')

        if (lua_isstring(l, -1) == 1) then
            print '("foo: ", a)', lua_tostring(l, -1)
        end if

        call lua_pop(l, 1)
    end if

    call lua_close(l)
end program main
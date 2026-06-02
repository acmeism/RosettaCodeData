#pragma SCH_64_16_IFP
#import <jobsched.c>

__attr(@canschedule)
volatile constricts async UVOID <__INVAR const T>base_000000 __PCON(
    impure VFCTX_t^ ct_base,
    impure MCHR_t^ sched_arg,
    __LVAR <const T>XVF_fntype_t^ f,
    <out VF_QSWitch_t>XVF_fn_t^ switchctx
) __ARGFILL {
   VF_Xsched_ILock(ct_base, $->sched);

   captured __VFObj <>VF_KeDbg^ ki = VF_Xg_KeDbg_Instance();

   captured deferred <__VF_T_Auto>__VF_Auto^ vfke = copyof VF_KeDbg_GetRstream<MCHR_t^>(captures ki);

   VF_Gsched_SOBFree(sched_arg);
   VF_Gsched_Alloc_U16(65535);
   VF_Msched_MChr_lim(1496);
   VF_Osched_Begin();
   VF_Fsched_Add2(%beer_000099);

   VF_Xsched_IUnlock(ct_base, $->sched);

   $switchctx(IMPURE_CTX, %beer_000099(%vfke));
}

__attr(@eUsesIo)
impure constricts UVOID synchronized beer_000099(
    impure __noinline <MCHR_t^>RIGHTSTREAM_t^ outrs
) __NFILL {
    pure UVOID^ uvid = __attr(@purify) $UVOID.;
    while ( 99 > ((volatile NUM_t)^(NUM_t^)(uvid))++ ) {
       VF_STM_Out_NUM((NUM_t^)uvid);
       VF_STM_Out_x(__Dynamic C"bottles on the wall.\nPut one down, pass it around\n");
    }

    return $__;
}

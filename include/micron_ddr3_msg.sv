`ifndef __GUARD_MICRON_DDR3_MSG_SVH__
`define __GUARD_MICRON_DDR3_MSG_SVH__

  typedef struct {
    int        msg_id;
    realtime   msg_time;
    string     msg_body;
  } msg_t;

  `define DDR3_MSG_ID_COUNTERS                                                   \
    int info_msg_id    = 0;                                                      \
    int warning_msg_id = 0;                                                      \
    int error_msg_id   = 0;                                                      \


  `define DDR3_MSG_MBX_DECLARE                                                   \
    mailbox #(msg_t) info_mbx   ;                                                \
    mailbox #(msg_t) warning_mbx;                                                \
    mailbox #(msg_t) error_mbx  ;                                                \


  `define DDR3_MSG_MBX_NEW                                                       \
    info_mbx    = new();                                                         \
    warning_mbx = new();                                                         \
    error_mbx   = new();                                                         \


  `define DDR3_MSG_MBX_INI_NEW                                                   \
    initial begin                                                                \
      `DDR3_MSG_MBX_NEW                                                          \
    end                                                                          \


  `define DDR3_MSG_MBX_CONNECT(__HIERARCHY__)                                    \
    ``__HIERARCHY__``.info_mbx    = info_mbx;                                    \
    ``__HIERARCHY__``.warning_mbx = warning_mbx;                                 \
    ``__HIERARCHY__``.error_mbx   = error_mbx;                                   \


  `define DDR3_MSG_TYPE_WRITES(__TYPE__)                                         \
    task automatic ``__TYPE__``_msg_write(input string txt);                     \
        msg_t msg;                                                               \
        msg.msg_time = $realtime;                                                \
        msg.msg_id   = ``__TYPE__``_msg_id;                                      \
        ``__TYPE__``_msg_id++;                                                   \
        $sformat(msg.msg_body , "%s", txt);                                      \
        while (``__TYPE__``_mbx == null) #10;                                    \
        void'(``__TYPE__``_mbx.try_put(msg));                                    \
    endtask                                                                      \


  `define DDR3_MSG_TYPE_WRITES                                                   \
    `DDR3_MSG_WRITES(info)                                                       \
    `DDR3_MSG_WRITES(warning)                                                    \
    `DDR3_MSG_WRITES(error)                                                      \


`endif

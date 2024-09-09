create database cloudstudy;
CREATE TABLE CmsAd (
   id VARCHAR(255) NOT NULL PRIMARY KEY COMMENT 'ID',
   title VARCHAR(255) COMMENT '标题',
   typeId VARCHAR(255) COMMENT '类型ID',
   imageUrl VARCHAR(255) COMMENT '图片地址',
   color VARCHAR(255) COMMENT '背景颜色',
   linkUrl VARCHAR(255) COMMENT '链接地址',
   sort INT COMMENT '排序',
   gmtCreate datetime  default CURRENT_TIMESTAMP not null comment '创建时间',
   gmtModified datetime   default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间'
) COMMENT='广告信息表';
CREATE TABLE `CmsAdType` (
     id VARCHAR(255) NOT NULL PRIMARY KEY COMMENT 'ID',
     title VARCHAR(255) COMMENT '标题',
     gmtCreate datetime  default CURRENT_TIMESTAMP not null comment '创建时间',
     gmtModified datetime   default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间'
) COMMENT='广告类型表';
CREATE TABLE `Cart` (
    `id` CHAR(32) NOT NULL COMMENT '唯一标识符',
    `courseId` VARCHAR(255) NOT NULL COMMENT '课程ID',
    `userId` VARCHAR(255) NOT NULL COMMENT '用户ID',
    `teacherName` VARCHAR(255) DEFAULT NULL COMMENT '教师姓名',
    `title` VARCHAR(255) DEFAULT NULL COMMENT '课程标题',
    `price` DECIMAL(10, 2) NOT NULL COMMENT '价格',
    `teacherId` VARCHAR(255) DEFAULT NULL COMMENT '教师ID',
    `cover` VARCHAR(255) DEFAULT NULL COMMENT '课程封面',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='购物车表';

CREATE TABLE t_order (
     id VARCHAR(32) NOT NULL COMMENT '订单ID',
     orderNo VARCHAR(50) NOT NULL COMMENT '订单号',
     courseId VARCHAR(50) NOT NULL COMMENT '课程ID',
     courseTitle VARCHAR(100) NOT NULL COMMENT '课程名称',
     courseCover VARCHAR(255) COMMENT '课程封面',
     teacherName VARCHAR(50) COMMENT '讲师名称',
     userId VARCHAR(50) NOT NULL COMMENT '用户ID',
     nickname VARCHAR(50) COMMENT '用户昵称',
     mobile VARCHAR(20) COMMENT '用户手机号码',
     totalFee DECIMAL(10, 2) NOT NULL COMMENT '订单金额（分）',
     payType TINYINT(4) NOT NULL COMMENT '支付类型（1：微信；2：支付宝）',
     status TINYINT(4) NOT NULL DEFAULT 0 COMMENT '订单状态（0：未支付；1：已支付）',
     isDeleted TINYINT(4) NOT NULL DEFAULT 0 COMMENT '逻辑删除标志（1：已删除；0：未删除）',
     createTime   datetime     default CURRENT_TIMESTAMP not null comment '创建时间',
     updateTime   datetime     default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
     PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单表';

CREATE TABLE PayLog (
     id VARCHAR(255) NOT NULL PRIMARY KEY COMMENT '主键ID',
     orderNo VARCHAR(255) COMMENT '订单号',
     payTime DATETIME COMMENT '支付完成时间',
     totalFee DECIMAL(10, 2) COMMENT '支付金额（分）',
     transactionId VARCHAR(255) COMMENT '交易流水号',
     tradeState VARCHAR(255) COMMENT '交易状态',
     payType INT COMMENT '支付类型（1：微信 2：支付宝）',
     attr VARCHAR(255) COMMENT '其他属性',
     isDeleted INT DEFAULT 0 COMMENT '逻辑删除 1（true）已删除， 0（false）未删除',
     createTime   datetime     default CURRENT_TIMESTAMP not null comment '创建时间',
     updateTime   datetime     default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间'
) COMMENT='支付日志表';
CREATE TABLE `Category` (
    `id` VARCHAR(32) NOT NULL COMMENT '课程类别ID',
    `title` VARCHAR(255) COMMENT '类别名称',
    `parentId` VARCHAR(32) COMMENT '父ID',
    `sort` INT COMMENT '排序字段',
    `createTime` DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL COMMENT '创建时间',
    `updateTime` DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='课程类别表';
CREATE TABLE  `Course` (
    id VARCHAR(255) NOT NULL PRIMARY KEY COMMENT '课程ID',
    teacherId VARCHAR(255) COMMENT '课程讲师ID',
    categoryParentId VARCHAR(255) COMMENT '一级分类ID',
    categoryId VARCHAR(255) COMMENT '具体类别ID',
    description TEXT COMMENT '课程简介',
    title VARCHAR(255) COMMENT '课程标题',
    price DECIMAL(10, 2) COMMENT '课程销售价格，设置为0则可免费观看',
    lessonNum INT COMMENT '总课时',
    cover VARCHAR(255) COMMENT '课程封面图片路径',
    buyCount BIGINT DEFAULT 0 COMMENT '销售数量',
    viewCount BIGINT DEFAULT 0 COMMENT '浏览数量',
    likeCount BIGINT DEFAULT 0 COMMENT '点赞数量',
    version BIGINT DEFAULT 0 COMMENT '乐观锁',
    status VARCHAR(20) COMMENT '视频状态 Draft未发布  Normal已发布',
    createTime   datetime     default CURRENT_TIMESTAMP not null comment '创建时间',
    updateTime   datetime     default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间'
) COMMENT='课程表';
CREATE TABLE `course_chapter` (
  `id` VARCHAR(255) NOT NULL COMMENT '章节ID',
  `courseId` VARCHAR(255) NOT NULL COMMENT '课程ID',
  `title` VARCHAR(255) NOT NULL COMMENT '章节名称',
  `sort` INT DEFAULT NULL COMMENT '显示排序',
  `createTime`   datetime     default CURRENT_TIMESTAMP not null comment '创建时间',
  `updateTime`   datetime     default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
  PRIMARY KEY (`id`)
) COMMENT='课程章节表';

CREATE TABLE `CourseCollect` (
  `id` VARCHAR(255) NOT NULL,          -- 收藏ID
  `courseId` VARCHAR(255) NOT NULL,   -- 课程ID
  `userId` VARCHAR(255) NOT NULL,     -- 用户ID
  isDeleted INT DEFAULT 0 COMMENT '逻辑删除 1（true）已删除， 0（false）未删除',
  createTime   datetime     default CURRENT_TIMESTAMP not null comment '创建时间',
  updateTime   datetime     default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `CourseLike` (
   `id` INT AUTO_INCREMENT,
   `courseId` VARCHAR(255) NOT NULL,
   `userId` VARCHAR(255) NOT NULL,
   `status` INT DEFAULT 0,
   `createTime`   datetime     default CURRENT_TIMESTAMP not null comment '创建时间',
   `updateTime`   datetime     default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
   PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE CourseVideo (
  id VARCHAR(255) NOT NULL PRIMARY KEY COMMENT '视频ID',
  courseId VARCHAR(255) COMMENT '课程ID',
  chapterId VARCHAR(255) COMMENT '章节ID',
  title VARCHAR(255) COMMENT '视频名称',
  sort INT COMMENT '排序字段 一个章节下面可以有多个视频',
  playCount BIGINT DEFAULT 0 COMMENT '播放次数',
  isFree BOOLEAN DEFAULT FALSE COMMENT '是否可以试听：0免费 1收费',
  videoSourceId VARCHAR(255) COMMENT '视频资源',
  videoOriginalName VARCHAR(255) COMMENT '视频原始文件名称',
  duration FLOAT COMMENT '视频时长（秒）',
  status VARCHAR(255) COMMENT '视频状态:见阿里云文档',
  size BIGINT COMMENT '视频源文件大小（字节）',
  version BIGINT DEFAULT 0 COMMENT '乐观锁',
  createTime   datetime     default CURRENT_TIMESTAMP not null comment '创建时间',
  updateTime   datetime     default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间'
) COMMENT='课程视频信息表';
CREATE TABLE `EduComment` (
   `id` varchar(255) NOT NULL COMMENT '评论ID',
   `courseId` varchar(255) DEFAULT NULL COMMENT '课程ID',
   `teacherId` varchar(255) DEFAULT NULL COMMENT '讲师ID',
   `memberId` varchar(255) DEFAULT NULL COMMENT '会员ID',
   `nickname` varchar(255) DEFAULT NULL COMMENT '会员昵称',
   `avatar` varchar(255) DEFAULT NULL COMMENT '会员头像',
   `content` text COMMENT '评论内容',
   `isDeleted` tinyint(1) DEFAULT 0 COMMENT '逻辑删除标志 1（true）已删除， 0（false）未删除',
   `createTime`   datetime     default CURRENT_TIMESTAMP not null comment '创建时间',
   `updateTime`   datetime     default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='评论表';
CREATE TABLE `static_daily` (
    `id` varchar(255) NOT NULL,
    `date_calculated` date NOT NULL,
    `register_num` int NOT NULL,
    `login_num` int NOT NULL,
    `video_view_num` int NOT NULL,
    `course_num` int NOT NULL,
    `createTime`   datetime     default CURRENT_TIMESTAMP not null comment '创建时间',
    `updateTime`   datetime     default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
     PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
CREATE TABLE `Teacher` (
   `id` varchar(255) NOT NULL COMMENT '讲师ID',
   `name` varchar(255) DEFAULT NULL COMMENT '讲师姓名',
   `intro` varchar(255) DEFAULT NULL COMMENT '讲师资历',
   `career` text COMMENT '讲师简介',
   `level` int DEFAULT NULL COMMENT '头衔 1高级讲师 2首席讲师 3普通讲师',
   `avatar` varchar(255) DEFAULT NULL COMMENT '讲师头像',
   `sort` int DEFAULT NULL COMMENT '排序',
   `is_deleted` tinyint(1) DEFAULT 0 COMMENT '逻辑删除 1（true）已删除， 0（false）未删除',
   `createTime`   datetime     default CURRENT_TIMESTAMP not null comment '创建时间',
   `updateTime`   datetime     default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='讲师信息表';
CREATE TABLE aclAdminRole (
    id VARCHAR(255) NOT NULL PRIMARY KEY COMMENT '主键id',
    roleId VARCHAR(255) COMMENT '角色id',
    userId VARCHAR(255) COMMENT '用户id',
    isDeleted INT DEFAULT 0 COMMENT '逻辑删除 1（true）已删除， 0（false）未删除',
    createTime   datetime     default CURRENT_TIMESTAMP not null comment '创建时间',
    updateTime   datetime     default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间'
) COMMENT='管理员角色信息表';
CREATE TABLE `AclPermission` (
      `id` VARCHAR(255) NOT NULL,
      `pid` VARCHAR(255),
      `name` VARCHAR(255),
      `type` INT,
      `permissionValue` VARCHAR(255),
      `url` VARCHAR(255),
      `path` VARCHAR(255),
      `component` VARCHAR(255),
      `icon` VARCHAR(255),
      `status` INT,
      `isDeleted` INT DEFAULT 0 COMMENT '逻辑删除 1（true）已删除， 0（false）未删除',
      `createTime`   datetime     default CURRENT_TIMESTAMP not null comment '创建时间',
      `updateTime`   datetime     default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
      PRIMARY KEY (`id`)
);
CREATE TABLE acl_role (
      id VARCHAR(255) NOT NULL,
      roleName VARCHAR(255),
      roleCode VARCHAR(255),
      remark VARCHAR(255),
      isDeleted INT DEFAULT 0 COMMENT '逻辑删除 1（true）已删除， 0（false）未删除',
      createTime   datetime     default CURRENT_TIMESTAMP not null comment '创建时间',
      updateTime   datetime     default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间',
      PRIMARY KEY (id)
);
CREATE TABLE AclRolePermission (
     id VARCHAR(255) NOT NULL PRIMARY KEY COMMENT '唯一标识符',
     roleId VARCHAR(255) NOT NULL COMMENT '角色ID',
     permissionId VARCHAR(255) NOT NULL COMMENT '权限ID',
     isDeleted INT DEFAULT 0 COMMENT '逻辑删除 1（true）已删除， 0（false）未删除',
     createTime   datetime     default CURRENT_TIMESTAMP not null comment '创建时间',
     updateTime   datetime     default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间'
) COMMENT='角色权限关系表';
CREATE TABLE Admin (
    id VARCHAR(255) NOT NULL PRIMARY KEY COMMENT 'ID',
    name VARCHAR(255) NOT NULL COMMENT '用户名',
    password VARCHAR(255) NOT NULL COMMENT '密码',
    avatar VARCHAR(255) COMMENT '头像',
    isDisabled INT NOT NULL DEFAULT 0 COMMENT '是否禁用 1（true）已禁用， 0（false）未禁用',
    isDeleted INT NOT NULL DEFAULT 0 COMMENT '逻辑删除 1（true）已删除， 0（false）未删除',
    createTime DATETIME NOT NULL COMMENT '创建时间',
    updateTime DATETIME COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='管理员表';

CREATE TABLE User (
   id VARCHAR(255) NOT NULL PRIMARY KEY COMMENT '用户ID',
   openid VARCHAR(255) COMMENT '微信openid',
   mobile VARCHAR(255) COMMENT '手机号',
   password VARCHAR(255) COMMENT '密码',
   nickname VARCHAR(255) COMMENT '昵称',
   sex INT COMMENT '性别 1 男，2 女',
   age INT COMMENT '年龄',
   avatar VARCHAR(255) COMMENT '用户头像',
   sign VARCHAR(255) COMMENT '用户签名',
   isDisabled INT COMMENT '是否禁用 1（true）已禁用， 0（false）未禁用',
   isDeleted INT DEFAULT 0 COMMENT '逻辑删除 1（true）已删除， 0（false）未删除',
   createTime   datetime     default CURRENT_TIMESTAMP not null comment '创建时间',
   updateTime   datetime     default CURRENT_TIMESTAMP not null on update CURRENT_TIMESTAMP comment '更新时间'
) COMMENT='用户表';


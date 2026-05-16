import {
  Injectable,
  OnModuleInit,
  OnModuleDestroy,
  Logger,
} from '@nestjs/common';
import { PrismaClient } from '@prisma/client';
import { PrismaPg } from '@prisma/adapter-pg';
import { Pool } from 'pg';

@Injectable()
export class PrismaService
  extends PrismaClient
  implements OnModuleInit, OnModuleDestroy
{
  private readonly logger = new Logger('PrismaService');

  constructor() {
    const pool = new Pool({
      connectionString:
        process.env.DATABASE_URL ??
        `postgresql://${process.env.DB_USER}:${process.env.DB_PASSWORD}@${process.env.DB_HOST}:${process.env.DB_PORT}/${process.env.DB_NAME}`,
    });

    super({ adapter: new PrismaPg(pool) });
  }

  async onModuleInit() {
    try {
      await this.$connect();
      this.logger.log('🟢 Database connected (Prisma)');
    } catch (err) {
      this.logger.error('🔴 Database connection failed', err);
      throw err;
    }
  }

  async onModuleDestroy() {
    await this.$disconnect();
    this.logger.log('🔵 Database disconnected');
  }
}

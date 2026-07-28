import { PrismaClient } from '@prisma/client';
import fs from 'fs';
import path from 'path';
import dotenv from 'dotenv';

dotenv.config();

const prisma = new PrismaClient();

async function runBackup() {
  const dateStr = new Date().toISOString().split('T')[0].replace(/-/g, '_');
  const jsonFilename = `backup_${dateStr}.json`;
  const jsonFilePath = path.join(process.cwd(), jsonFilename);

  console.log(`Starting database backup to ${jsonFilename}...`);

  try {
    const [
      users,
      coaches,
      parents,
      players,
      groups,
      payments,
      attendance,
      evaluations,
      messages,
      trainings
    ] = await Promise.all([
      prisma.user.findMany(),
      prisma.coach.findMany(),
      prisma.parent.findMany(),
      prisma.player.findMany(),
      prisma.group.findMany(),
      prisma.payment.findMany(),
      prisma.attendance.findMany(),
      prisma.evaluation.findMany(),
      prisma.message.findMany(),
      prisma.training.findMany()
    ]);

    const backupData = {
      timestamp: new Date().toISOString(),
      counts: {
        users: users.length,
        coaches: coaches.length,
        parents: parents.length,
        players: players.length,
        groups: groups.length,
        payments: payments.length,
        attendance: attendance.length,
        evaluations: evaluations.length,
        messages: messages.length,
        trainings: trainings.length
      },
      data: {
        users,
        coaches,
        parents,
        players,
        groups,
        payments,
        attendance,
        evaluations,
        messages,
        trainings
      }
    };

    fs.writeFileSync(jsonFilePath, JSON.stringify(backupData, null, 2), 'utf-8');
    console.log(`Backup completed successfully! Saved to: ${jsonFilePath}`);
    console.log('Record counts:', backupData.counts);
  } catch (error) {
    console.error('Backup failed:', error);
    process.exit(1);
  } finally {
    await prisma.$disconnect();
  }
}

runBackup();
